# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @q = '上海'
    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(id: :asc)
    @mat_ids = params[:ms].presence || []
    @selected_mats = Material.where(id: @mat_ids)
    @locations = params[:l].presence || []
    @materials = Material.where(parent_id: Material.find_by(name: '石材').id, display: 1, deleted_at: nil).order(id: :asc)
    @cases = if @q.present?
      Cases.where('project_name LIKE ? OR business_type LIKE ? OR project_type LIKE ? OR project_location LIKE ? OR design_unit LIKE ?',
        "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%")
    else
      Cases.none
    end
  end

  def show
    @project = Cases.find(params[:id])
    material_ids = @project.materials.pluck(:id)
    sample_ids = @project.samples.pluck(:id)
    case_ids = CasesMaterial.where('(type_id = 2 AND material_id IN (?)) OR (type_id = 1 AND sample_id IN (?))', material_ids, sample_ids).pluck(:case_id).uniq
    @other_projects = Cases.where.not(id: @project.id).order(Arel.sql("CASE WHEN id IN (#{case_ids.join(',').presence || 'NULL'}) THEN 2 ELSE 1 END DESC")).limit(5)
  end
end
