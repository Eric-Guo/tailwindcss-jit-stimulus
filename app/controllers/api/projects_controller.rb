# frozen_string_literal: true

module Api
  class ProjectsController < ApplicationController
    def index
      @list = Cases.order(updated_at: :desc)

      # 关键词
      keywords = ActiveRecord::Base::sanitize_sql(params[:keywords]&.strip)
      if keywords.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{keywords}%").pluck(:material_id)
        case_ids = CasesMaterial.where(material_id: q_mat_ids).pluck(:case_id)
        @list = @list.where('project_name LIKE :q_like OR business_type LIKE :q_like OR project_type LIKE :q_like OR project_location LIKE :q_like OR design_unit LIKE :q_like OR id IN (:case_ids)', q_like: "%#{keywords}%", case_ids: case_ids)
      end

      # 材料筛选
      mat1_id = params[:mat1_id].presence&.strip
      mat_ids = params[:mat_ids].is_a?(Array) ? params[:mat_ids] : (params[:mat_ids].presence&.split(',') || [])
      mat_ids = mat_ids.reject(&:blank?).collect(&:to_i)

      if mat_ids.blank? && mat1_id.present?
        mat_ids = Material.where(level: 2).where(parent_id: mat1_id).pluck(:id)
      end

      if mat1_id.present?
        case_ids = CasesMaterial.where(material_id: mat_ids).pluck(:case_id)
        @list = @list.where('id IN (?)', case_ids)
      end

      # 地区ID
      area_ids = params[:area_ids].is_a?(Array) ? params[:area_ids] : (params[:area_ids].presence&.split(',') || [])
      area_ids = area_ids.reject(&:blank?).collect(&:to_i)
      if area_ids.present?
        @list = @list.where('area_id IN (?)', area_ids)
      end

      # 项目类型
      project_type = params[:project_type].presence
      if project_type.present?
        @list = @list.where(project_type: project_type)
      end

      # 是否有里面控制手册
      has_lmkzsc = params[:has_lmkzsc] == 'true'
      if has_lmkzsc.present?
        case_ids = CaseLmkzsc.pluck(:cases_id)
        @list = @list.where('id IN (?)', case_ids)
      end

      # 是否有样品
      has_sample = params[:has_sample] == 'true'
      if has_sample.present?
        case_ids = CasesMaterial.joins(:case_material_samples).pluck(:case_id)
        @list = @list.where('id IN (?)', case_ids)
      end

      # 是否是示范区
      is_demonstration = params[:has_demonstration] == 'true'
      if is_demonstration.present?
        @list = @list.where(is_da: true)
      end

      is_th = params[:is_th] == 'true'
      if is_th.present?
        @list = @list.where(is_th: true)
      end

      @total = @list.count

      page, page_size = pagination_params
      @list = @list.includes(:materials, :area).page(page).per(page_size)
    end

    def show
      @project = Cases.find(params[:id])
    end

    def related_projects
      project = Cases.find(params[:id])
      material_ids = project.materials.pluck(:id)
      case_ids = CasesMaterial.where('material_id IN (?)', material_ids).pluck(:case_id).uniq
      @list = Cases.where.not(id: project.id).order(Arel.sql("CASE WHEN id IN (#{case_ids.join(',').presence || 'NULL'}) THEN 2 ELSE 1 END DESC"))

      @total = @list.count

      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end
  end
end
