# frozen_string_literal: true

class SamplesController < ApplicationController
  def show
    @sample = Sample.find_by!(no: params[:id])

    case_ids = CasesMaterial.where(type: 1, sample_id: @sample.id).pluck(:case_id)
    @cases = Cases.where(id: case_ids).limit(2)

    @other_samples = Sample.where.not(id: @sample.id).limit(2)

    # breadcrumb

  end

  def next_other_samples
    @sample = Sample.find_by!(no: params[:id])
    @other_samples = Sample.where.not(id: @sample.id).limit(2).offset(2)
  end

  def prev_other_samples
    @sample = Sample.find_by!(no: params[:id])
    @other_samples = Sample.where.not(id: @sample.id).limit(2)
  end

  def next_projects
    @sample = Sample.find_by!(no: params[:id])
    case_ids = CasesMaterial.where(type: 1, sample_id: @sample.id).pluck(:case_id)
    @cases = Cases.where(id: case_ids).limit(2).offset(2)
  end

  def prev_projects
    @sample = Sample.find_by!(no: params[:id])
    case_ids = CasesMaterial.where(type: 1, sample_id: @sample.id).pluck(:case_id)
    @cases = Cases.where(id: case_ids).limit(2).limit(2)
  end
end
