# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def index
    if turbo_frame_request?
      @page_size_options = [10, 15, 25, 40, 60, 85]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

      mat_ids = (params[:ms].presence || []).reject(&:blank?)

      @area_ids = (params[:l].presence || []).reject(&:blank?).map(&:to_i)

      @project_type = params[:project_type].presence
      @need_ecm_files = params[:ecm_files] == 'on'
      @has_sample = params[:has_sample] == 'on'
      @has_demonstration = params[:has_demonstration] == 'on'
      @is_th_internal = params[:is_th_internal] == 'on'

      @cases = Cases.order(updated_at: :desc)
      
      if @q.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{@q}%").pluck(:material_id)
        case_ids = CasesMaterial.where(type_id: 2).where(material_id: q_mat_ids).pluck(:case_id)
        @cases = @cases.where('project_name LIKE :q_like OR business_type LIKE :q_like OR project_type LIKE :q_like OR project_location LIKE :q_like OR design_unit LIKE :q_like OR id IN (:case_ids)', q_like: "%#{@q}%", case_ids: case_ids)
      end

      if mat_ids.present?
        case_ids = CasesMaterial.where(type_id: 2).where(material_id: mat_ids).pluck(:case_id)
        @cases = @cases.where('id IN (?)', case_ids)
      end

      if @area_ids.present?
        @cases = @cases.where('area_id IN (?)', @area_ids)
      end

      if @project_type.present?
        @cases = @cases.where(project_type: @project_type)
      end

      if @need_ecm_files.present?
        @cases = @cases.where(lmkzsc_id: Lmkzsc.pluck(:id))
      end

      if @has_sample.present?
        case_ids = CasesMaterial.where(type_id: 1).pluck(:case_id)
        @cases = @cases.where('id IN (?)', case_ids)
      end

      if @has_demonstration.present?
        @cases = @cases.where(is_da: true)
      end

      if @is_th_internal.present?
        @cases = @cases.where(is_th: true)
      end

      @total = @cases.count
      @cases = @cases.page(@page).per(@page_size)

      @material_in_cases = CasesMaterial.joins(:material).where(type_id: 2).where(case_id: @cases.collect(&:id)).pluck('case_id, materials.name')

      render 'list'
    end

  end

  def show
    @project = Cases.find(params[:id])
    material_ids = @project.materials.pluck(:id)
    case_ids = CasesMaterial.where('material_id IN (?)', material_ids).pluck(:case_id).uniq
    @other_projects = Cases.where.not(id: @project.id).order(Arel.sql("CASE WHEN id IN (#{case_ids.join(',').presence || 'NULL'}) THEN 2 ELSE 1 END DESC")).limit(5)
  end
end
