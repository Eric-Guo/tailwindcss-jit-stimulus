# frozen_string_literal: true

class ManufacturersController < ApplicationController
  def index
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
    @other_manufacturers = Manufacturer.limit(4)
    @materials = @manufacturer.materials.where(level: 3)
    @samples = @manufacturer.samples
    @cases = Cases.joins(:materials).where(materials: { id: @materials.pluck(:id) }).distinct
  end
end
