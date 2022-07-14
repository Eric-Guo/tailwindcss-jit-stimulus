# frozen_string_literal: true

class ManufacturerRecordsController < ApplicationController
  def show
    @manufacturer = ManufacturerRecord.joins(:external_user).where(external_user: { id: params[:id] }).take!
    @cases = @manufacturer.external_user.cases
    case_materials = CasesMaterial.where(case_delegate_record_id: @cases.pluck(:id))
    @materials = Material.where(id: case_materials.pluck(:material_id))
    case_material_samples = CaseMaterialSample.where(cases_material_id: case_materials.pluck(:id))
    @samples = Sample.where(id: case_material_samples.pluck(:sample_id))
  end
end
