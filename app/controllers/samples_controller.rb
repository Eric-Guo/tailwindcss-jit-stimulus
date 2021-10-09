# frozen_string_literal: true

class SamplesController < ApplicationController
  def show
    @sample = Sample.find_by!(no: params[:id])

    # 所属案例
    @caseIds = CasesMaterial.where(type:1, sample_id:@sample.id).pluck(:case_id)
    @cases = Cases.where(id: @caseIds)

    # 其他样品

  end
end
