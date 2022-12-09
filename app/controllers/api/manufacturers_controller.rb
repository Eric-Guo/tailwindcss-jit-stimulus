# frozen_string_literal: true

module Api
  class ManufacturersController < ApplicationController
    def index
      @list = Manufacturer.sort_by_logo.order(is_allow: :desc).order(id: :asc)

      # 关键词
      keywords = ActiveRecord::Base::sanitize_sql(params[:keywords]&.strip)
      if keywords.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{keywords}%").pluck(:material_id)
        manufacturer_ids = MaterialManufacturer.where(material_id: q_mat_ids).pluck(:manufacturer_id)
        @list = @list.where('name LIKE :q_like OR location LIKE :q_like OR address LIKE :q_like OR website LIKE :q_like OR id IN (:manufacturer_ids)', q_like: "%#{keywords}%", manufacturer_ids: manufacturer_ids)
      end

      # 材料
      mat1_id = params[:mat1_id].presence&.strip
      mat_ids = params[:mat_ids].is_a?(Array) ? params[:mat_ids] : (params[:mat_ids].presence&.split(',') || [])
      mat_ids = mat_ids.reject(&:blank?).collect(&:to_i)

      if mat_ids.blank? && mat1_id.present?
        mat_ids = Material.where(level: 2).where(parent_id: mat1_id).pluck(:id)
      end

      if mat1_id.present?
        manufacturer_ids = MaterialManufacturer.where(material_id: mat_ids).pluck(:manufacturer_id)
        @list = @list.where('id IN (?)', manufacturer_ids)
      end

      # 服务区域
      area_ids = params[:area_ids].is_a?(Array) ? params[:area_ids] : (params[:area_ids].presence&.split(',') || [])
      area_ids = area_ids.reject(&:blank?).collect(&:to_i)
      if area_ids.present?
        manufacturer_ids = ManufacturerArea.where(area_id: area_ids).pluck(:manufacturer_id)
        @list = @list.where('id IN (?)', manufacturer_ids)
      end

      # 是否愿意提供样品
      sample_is_allow = params[:sample_is_allow] == 'true'
      if sample_is_allow.present?
        @list = @list.where(is_allow: true)
      end

      # 有关联案例
      has_related_cases = params[:has_related_cases] == 'true'
      if has_related_cases.present?
        @list = @list.where('id IN (?)', CaseManufacturer.select(:manufacturer_id).where.not(manufacturer_id: nil))
      end

      # 与天华合作过
      has_cooperate_th = params[:has_cooperate_th] == 'true'
      if has_cooperate_th.present?
        @list = @list.where(is_tho_co: true)
      end

      @total = @list.count

      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end

    def show
      @manufacturer = Manufacturer.find(params[:id])
      @samples = @manufacturer.samples.joins(:material)
      @projects = @manufacturer.cases
      @materials = @manufacturer.materials.where(level: 3)
      @news = @manufacturer.news
    end

    def related_manufacturers
      manufacturer = Manufacturer.find(params[:id])
      material3_ids = manufacturer.materials.where(level: 3).pluck(:id)
      material2_ids = manufacturer.materials.where(level: 2).pluck(:id)
      if material2_ids.present?
        material_ids = Material.where(level: 3).where(parent_id: material2_ids).pluck(:id)
        material2_ids.push(*material_ids) if material_ids.present?
      end
      material1_ids = manufacturer.materials.where(level: 1).pluck(:id)
      if material1_ids.present?
        material_ids = Material.where(level: [2, 3]).where("parent_id IN (:ids) OR grandpa_id IN (:ids)", ids: material1_ids)
        material1_ids.push(*material1_ids) if material_ids.present?
      end
      @list = Manufacturer.where.not(id: manufacturer.id)

      @total = @list.count

      manufacturer_fields = ['id', 'logo', 'name', 'location', 'address', 'is_allow', 'company_tel']
      page, page_size = pagination_params
      @list = @list
        .select(Arel.sql("#{manufacturer_fields.map { |field| '`manufacturers`.' + field }.join(',')}, \
          MAX(( \
            CASE \
            WHEN `materials`.id IN (#{material3_ids.join(',').presence || 'null'}) THEN 3 \
            WHEN `materials`.id IN (#{material2_ids.join(',').presence || 'null'}) THEN 2 \
            WHEN `materials`.id IN (#{material1_ids.join(',').presence || 'null'}) THEN 1 \
            ELSE 0 \
            END \
          )) AS sort_num \
        "))
        .joins(:materials)
        .group(manufacturer_fields.map { |field| '`manufacturers`.' + field }.join(','))
        .order(Arel.sql("sort_num DESC, id ASC"))
        .page(page)
        .per(page_size)
    end
  end
end
