# frozen_string_literal: true

module Api
  class SamplesController < ApplicationController
    def show
      @sample = Sample.find(params[:id])
    end

    def projects
      case_ids = CasesMaterial.joins(:case_material_samples).where(case_material_samples: { sample_id: params[:id] }).pluck(:case_id)
      @list = Cases.where(id: case_ids)
      @total = @list.count
      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end

    def related_samples
      sample = Sample.find(params[:id])
      material = sample.material
      sample_ids = []
      if material.present? && material.level == 3
        material_id = material.id
        brother_material_ids = Material.where(parent_id: material.parent_id).pluck(:id)
        other_material_ids = Material.where(parent_id: Material.select(:parent_id).where.not(id: material.parent_id).where(grandpa_id: material.grandpa_id)).pluck(:id)
        sample_ids.push(material_id)
        sample_ids.push(*brother_material_ids)
        sample_ids.push(*other_material_ids)
      end
      @list = Sample.where.not(id: sample.id).where(obj_id: sample_ids)
      if material.present? && brother_material_ids.present?
        @list = @list.order(Arel.sql("CASE WHEN obj_id = #{material_id} THEN 2 WHEN obj_id IN (#{brother_material_ids.join(',')}) THEN 1 ELSE 0 END DESC, id ASC")).order(id: :asc)
      end
      @total = @list.count
      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end
  end
end
