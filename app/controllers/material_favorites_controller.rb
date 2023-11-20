# frozen_string_literal: true

class MaterialFavoritesController < ApplicationController
  before_action do
    @material = Material.find(params[:material_id])
  end

  def new
  end
end
