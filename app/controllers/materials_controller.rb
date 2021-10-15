# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @materials = Material.includes(:children_materials).where(level: 1).all
    @material = Material.find_by!(id: params[:id])
  end
end
