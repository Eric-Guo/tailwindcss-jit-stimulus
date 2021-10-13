# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @color_systems = ColorSystem.all
    @material = Material.find_by!(id: params[:id])
  end
end
