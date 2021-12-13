# frozen_string_literal: true

class ManufacturersController < ApplicationController
  def index
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
    @materials = @manufacturer.materials.where(level: 3)
    @samples = @manufacturer.samples
    @cases = Cases.joins(:materials).where(materials: { id: @materials.pluck(:id) }).distinct
    @other_manufacturers = Manufacturer.joins(:materials).where.not(id: @manufacturer.id).where(materials: { id: @materials.pluck(:id) }).limit(4).distinct
  end
end
