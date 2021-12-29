# frozen_string_literal: true

class SamplesController < ApplicationController
  before_action :authenticate_user!

  def show
    @sample = Sample.find_by(id: params[:id]) || Sample.find_by!(no: params[:id])

    case_ids = CasesMaterial.select(:case_id).where(type_id: 1, sample_id: @sample.id).pluck(:case_id)
    @cases = Cases.where(id: case_ids).page(1).per(3)
    @other_samples = get_other_samples(@sample, 1, 2)
  end

  def other_samples
    sample = Sample.find_by(id: params[:id]) || Sample.find_by!(no: params[:id])
    @other_samples = get_other_samples(sample, params[:page], params[:page_size])
  end

  def projects
    case_ids = CasesMaterial.select(:case_id).where(type_id: 1, sample_id: params[:id]).pluck(:case_id)
    @cases = Cases.where(id: case_ids).page(params[:page]).per(params[:page_size])
  end

  private

    def get_other_samples(sample, page = 1, page_size = 2)
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
      other_samples = Sample.where.not(id: sample.id).where(obj_id: sample_ids)
      if material.present? && brother_material_ids.present?
        other_samples = other_samples.order(Arel.sql("CASE WHEN obj_id = #{material_id} THEN 2 WHEN obj_id IN (#{brother_material_ids.join(',')}) THEN 1 ELSE 0 END DESC, id ASC"))
      end
      other_samples.page(page).per(page_size)
    end
end
