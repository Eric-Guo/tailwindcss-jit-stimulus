# frozen_string_literal: true

class ManufacturersController < ApplicationController
  before_action :authenticate_user!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def index
    @page_size_options = [12, 20, 32, 56, 104]
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

    @panel_name = params[:pn].presence
    @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(no: :asc)
    mat_ids = (params[:ms].presence || []).reject(&:blank?)
    @selected_mats = if mat_ids.present?
      Material.where(id: mat_ids)
    else
      Material.none
    end
    @selected_mat_parent_id = @selected_mats.collect(&:parent_id).first || 1
    @area_ids = (params[:l].presence || []).reject(&:blank?).map(&:to_i)
    @sample_is_allow = params[:sample_is_allow] == 'on'
    @has_related_cases = params[:has_related_cases] == 'on'
    @has_cooperate_th = params[:has_cooperate_th] == 'on'

    @all_materials = Material.where(parent_id: @selected_mat_parent_id, display: 1, deleted_at: nil).order(no: :asc)
    @selected_all_materials = @all_materials.pluck(:id) == mat_ids.collect(&:to_i)
    @selected_none_materials = (@all_materials.pluck(:id) & mat_ids.collect(&:to_i)).blank?

    @selected_all_locations = Manufacturer.manufacturer_locations.collect(&:area_id) == @area_ids
    @selected_none_locations = (Manufacturer.manufacturer_locations.collect(&:area_id) & @area_ids).blank?

    manufacturer_with_query = if @q.present?
      mat_q_ids = q_return_mat_ids(@q)
      if mat_q_ids.present?
        manu_ids = Manufacturer.joins(:materials).where(materials: { id: mat_q_ids }).pluck(:id)
        Manufacturer.where(id: manu_ids)
      else
        Manufacturer.where('name LIKE ? OR location LIKE ? OR contact LIKE ? OR contact_information LIKE ? OR address LIKE ? OR website LIKE ?',
          "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%").sort_by_logo(:desc).order(is_allow: :desc)
      end
    else
      Manufacturer.all
    end

    manufacturer_with_materials = if mat_ids.present?
      manufacturer_with_query.includes(:materials).where(materials: { id: mat_ids.append(@selected_mat_parent_id) })
    else
      manufacturer_with_query
    end

    manufacturer_with_location = if @area_ids.present?
      manufacturer_with_materials.joins(:manufacturer_areas).where(manufacturer_areas: { area_id: @area_ids }).distinct
    else
      manufacturer_with_materials
    end

    manufacturer_sample_allow = if @sample_is_allow.present?
      manufacturer_with_location.where(is_allow: true)
    else
      manufacturer_with_location
    end

    manufacturer_has_related_cases = if @has_related_cases.present?
      manufacturer_sample_allow.where.not(cases: ['null', '', '[]']).where.not(cases: nil)
    else
      manufacturer_sample_allow
    end

    manufacturer_has_cooperate_th = if @has_cooperate_th.present?
      manufacturer_has_related_cases.where(is_tho_co: true)
    else
      manufacturer_has_related_cases
    end

    @total = manufacturer_has_cooperate_th.count
    @manufacturers = manufacturer_has_cooperate_th.page(@page).per(@page_size)
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
    @materials = @manufacturer.materials.where(level: 3)
    @samples = @manufacturer.samples
    @cases = Cases.joins(:samples).where(samples: { id: @samples.pluck(:id) }).distinct
    @news = @manufacturer.news
    material3_ids = @manufacturer.materials.where(level: 3).pluck(:id)
    material2_ids = @manufacturer.materials.where(level: 2).pluck(:id)
    if material2_ids.present?
      material_ids = Material.where(level: 3).where(parent_id: material2_ids).pluck(:id)
      material2_ids.push(*material_ids) if material_ids.present?
    end
    material1_ids = @manufacturer.materials.where(level: 1).pluck(:id)
    if material1_ids.present?
      material_ids = Material.where(level: [2, 3]).where("parent_id IN (:ids) OR grandpa_id IN (:ids)", ids: material1_ids)
      material1_ids.push(*material1_ids) if material_ids.present?
    end
    manufacturer_fields = ['id', 'logo', 'name', 'location', 'address', 'is_allow', 'contact_information']
    @other_manufacturers = Manufacturer
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
      .where.not(id: @manufacturer.id)
      .group(manufacturer_fields.map { |field| '`manufacturers`.' + field }.join(','))
      .order(Arel.sql("sort_num DESC, id ASC"))
      .limit(4)
  end
end
