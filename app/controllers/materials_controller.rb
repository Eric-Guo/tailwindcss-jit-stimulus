# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @material = Material.find_by!(id: params[:id])
  end
end
