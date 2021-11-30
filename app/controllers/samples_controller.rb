# frozen_string_literal: true

class SamplesController < ApplicationController
  def show
    @sample = Sample.find_by(id: params[:id]) || Sample.find_by!(no: params[:id])

    case_ids = CasesMaterial.select(:case_id).where(type_id: 1, sample_id: @sample.id).pluck(:case_id)
    @cases = Cases.where(id: case_ids).page(1).per(3)
    @other_samples = Sample.where.not(id: @sample.id).page(1).per(2)

    # breadcrumb
  end

  def other_samples
    @other_samples = Sample.where.not(id: params[:id]).page(params[:page]).per(params[:page_size])
  end

  def projects
    case_ids = CasesMaterial.select(:case_id).where(type_id: 1, sample_id: params[:id]).pluck(:case_id)
    @cases = Cases.where(id: case_ids).page(params[:page]).per(params[:page_size])
  end
end
