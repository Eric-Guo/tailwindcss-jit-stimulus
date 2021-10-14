# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @material = Material.includes(material_product: :color_systems).find_by!(id: params[:id])
  end
end
