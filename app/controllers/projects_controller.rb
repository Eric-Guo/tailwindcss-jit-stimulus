# frozen_string_literal: true

class ProjectsController < ApplicationController
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
    @need_ecm_files = params[:ecm_files] == 'on'
    @has_sample = params[:has_sample] == 'on'
    @has_demonstration = params[:has_demonstration] == 'on'
    @is_th_internal = params[:is_th_internal] == 'on'

    @all_materials = Material.where(parent_id: @selected_mat_parent_id, display: 1, deleted_at: nil).order(id: :asc)
    @selected_all_materials = @all_materials.pluck(:id) == mat_ids.collect(&:to_i)
    @selected_none_materials = (@all_materials.pluck(:id) & mat_ids.collect(&:to_i)).blank?

    @selected_all_locations = Cases.project_locations == @locations
    @selected_none_locations = (Cases.project_locations & @locations).blank?

    cases_with_query = if @q.present?
      mat_ids = q_return_mat_ids(@q)

      if mat_ids.present?
        Cases.left_joins(:case_materials).where(case_materials: { material_id:  mat_ids})
      else
        Cases.where('project_name LIKE ? OR business_type LIKE ? OR project_type LIKE ? OR project_location LIKE ? OR design_unit LIKE ?', "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%")
      end
    else
      Cases.all
    end.select('cases.id, cases.is_th, cases.web_cover, cases.project_name, cases.project_location')

    cases_with_materials = if mat_ids.present?
      cases_with_query.includes(:case_materials).where(case_materials: { material_id: mat_ids.append(@selected_mat_parent_id) })
    else
      cases_with_query
    end

    cases_with_location = if @locations.present?
      cases_with_materials.where(project_location: @locations)
    else
      cases_with_materials
    end

    cases_ecm = if @need_ecm_files
      cases_with_location.where.not(ecm_files: '[]')
    else
      cases_with_location
    end

    @cases = cases_ecm.limit(40)
    @material_in_cases = CasesMaterial.joins(:material).where(case_id: @cases.collect(&:id)).pluck('case_id, materials.name')
  end

  def show
    @project = Cases.find(params[:id])
    material_ids = @project.materials.pluck(:id)
    sample_ids = @project.samples.pluck(:id)
    case_ids = CasesMaterial.where('(type_id = 2 AND material_id IN (?)) OR (type_id = 1 AND sample_id IN (?))', material_ids, sample_ids).pluck(:case_id).uniq
    @other_projects = Cases.where.not(id: @project.id).order(Arel.sql("CASE WHEN id IN (#{case_ids.join(',').presence || 'NULL'}) THEN 2 ELSE 1 END DESC")).limit(5)
  end
end
