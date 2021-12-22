# frozen_string_literal: true

class ManufacturersController < ApplicationController
  def index
    @panel_name = params[:pn].presence
    @q = ActiveRecord::Base::sanitize_sql(params[:q])

    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(id: :asc)
    mat_ids = (params[:ms].presence || []).reject(&:blank?)
    @selected_mats = if mat_ids.present?
      Material.where(id: mat_ids)
    else
      Material.none
    end
    @selected_mat_parent_id = @selected_mats.collect(&:parent_id).first || 1
    @locations = (params[:l].presence || []).reject(&:blank?)
    @project_type = params[:project_type].presence
    @has_related_cases = params[:has_related_cases] == 'on'
    @has_cooperate_th = params[:has_cooperate_th] == 'on'

    @all_materials = Material.where(parent_id: @selected_mat_parent_id, display: 1, deleted_at: nil).order(id: :asc)
    @selected_all_materials = @all_materials.pluck(:id) == mat_ids.collect(&:to_i)
    @selected_none_materials = (@all_materials.pluck(:id) & mat_ids.collect(&:to_i)).blank?

    @selected_all_locations = Manufacturer.manufacturer_locations == @locations
    @selected_none_locations = (Manufacturer.manufacturer_locations & @locations).blank?

    manufacturer_with_query = if @q.present?
      mat_q_ids = q_return_mat_ids(@q)
      if mat_q_ids.present?
        Manufacturer.joins(:materials).where(materials: { id: mat_q_ids })
      else
        Manufacturer.where('name LIKE ? OR location LIKE ? OR contact LIKE ? OR contact_information LIKE ? OR address LIKE ? OR website LIKE ?',
          "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%").sort_by_logo(:desc).order(is_allow: :desc)
      end
    else
      Manufacturer.all
    end.limit(40)

    manufacturer_with_materials = if mat_ids.present?
      manufacturer_with_query.includes(:materials).where(materials: { id: mat_ids.append(@selected_mat_parent_id) })
    else
      manufacturer_with_query
    end

    manufacturer_with_location = if @locations.present?
      manufacturer_with_materials.where(location: @locations)
    else
      manufacturer_with_materials
    end

    manufacturer_has_related_cases = if @has_related_cases.present?
      manufacturer_with_location.where.not(cases: ['null', '', '[]']).where.not(cases: nil)
    else
      manufacturer_with_location
    end

    manufacturer_has_cooperate_th = if @has_cooperate_th.present?
      manufacturer_has_related_cases.where(is_tho_co: true)
    else
      manufacturer_has_related_cases
    end

    @manufacturers = manufacturer_has_cooperate_th.limit(40)
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
    @materials = @manufacturer.materials
    @samples = @manufacturer.samples
    @cases = Cases.joins(:samples).where(samples: { id: @samples.pluck(:id) }).distinct
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
    @other_manufacturers = Manufacturer.select('manufacturers.*, materials.id as material_id').joins(:materials)
      .where.not(id: @manufacturer.id)
      .order(Arel.sql("( \
        CASE \
        WHEN materials.id IN (#{material3_ids.join(',').presence || 'null'}) THEN 3 \
        WHEN materials.id IN (#{material2_ids.join(',').presence || 'null'}) THEN 2 \
        WHEN materials.id IN (#{material1_ids.join(',').presence || 'null'}) THEN 1 \
        ELSE 0 \
        END \
      ) DESC, id ASC"))
      .limit(4).distinct
  end
end
