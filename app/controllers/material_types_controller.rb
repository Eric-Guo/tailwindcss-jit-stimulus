# frozen_string_literal: true

class MaterialTypesController < ApplicationController
  def show
    @from = params[:from]
    @material_type = Material.find(params[:id])
    @materials = Material.where(parent_id: @material_type.id, display: 1, deleted_at: nil).order(id: :asc)
    render content_type: 'text/vnd.turbo-stream.html'
  end
end
