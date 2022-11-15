# frozen_string_literal: true

module Api
  class MaterialsController < ApplicationController
    def index
      @list = MaterialAndSample.where.not(material_level: 1).order(material_no: :asc, sample_id: :asc)

      # 关键词
      keywords = ActiveRecord::Base::sanitize_sql(params[:keywords]&.strip)
      if keywords.present?
        @list = @list.where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{keywords}%")
      end

      # 材料筛选
      mat1_id = params[:mat1_id].presence&.strip
      mat_ids = params[:mat_ids].is_a?(Array) ? params[:mat_ids] : (params[:mat_ids].presence&.split(',') || [])
      mat_ids = mat_ids.reject(&:blank?).collect(&:to_i)

      if mat_ids.blank? && mat1_id.present?
        mat_ids = Material.where(level: 2).where(parent_id: mat1_id).pluck(:id)
      end

      if mat1_id.present?
        @list = @list.where('material_id IN (:ids) OR parent_material_id IN (:ids)', ids: mat_ids)
      end

      # 色系
      color_system_id = params[:color_system_id].presence&.strip
      if color_system_id.present?
        color_mat_ids = MaterialProduct.joins(:material_product_color_systems).where(material_product_color_systems: { color_systems_id: color_system_id }).pluck(:material_id)
        color_sam_ids = SampleColorSystem.where(color_systems_id: color_system_id).pluck(:sample_id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', color_mat_ids, color_sam_ids)
      end

      # 价格
      price_start = params[:price_start].presence&.to_f
      price_end = params[:price_end].presence&.to_f
      if price_start.present? && price_end.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', price_start, price_end).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', price_start, price_end).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', price_start, price_end).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      elsif price_start.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(low_price, SIGNED) <= ?', price_start).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(low_price, SIGNED) <= ?', price_start).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(low_price, SIGNED) <= ?', price_start).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      elsif price_end.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(high_price, SIGNED) >= ?', price_end).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(high_price, SIGNED) >= ?', price_end).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(high_price, SIGNED) >= ?', price_end).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      end

      # 地区
      area_id = params[:area_id].presence
      if area_id.present?
        area_mat_ids = MaterialProduct.joins(:material_product_areas).where(material_product_areas: { area_id: area_id }).pluck(:material_id)
        @list = @list.where('material_id IN (?)', area_mat_ids)
      end

      @total = @list.count

      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end

    def show
      @material = Material.find(params[:id])
    end

    def children
      @list = Material.includes(material_product: [:color_systems]).where(parent_id: params[:id]).order(no: :asc).all
    end

    def color_systems
      material = Material.find(params[:id])
      material_ids = material.children_materials.pluck(:id)
      color_system_ids = MaterialProductColorSystem.where(material_product_id: MaterialProduct.select(:id).where(material_id: material_ids)).pluck(:color_systems_id)
      @color_systems = ColorSystem.where(id: color_system_ids)
    end

    def paths
      @material = Material.find(params[:id])
    end

    def samples
      @material = Material.find(params[:id])
    end
  end
end
