# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @material = Material.find_by!(id: params[:id])
    @materials = Material.includes(:children_materials).where(level: 1).all

    @color_id = params["color_id"]
    query = Material
    if @color_id
      query = query.joins("LEFT JOIN material_products AS products ON products.material_id = materials.id")
      query = query.joins("LEFT JOIN material_product_color_systems AS mpc ON mpc.material_product_id = products.id")
      query = query.where("mpc.color_systems_id = " + @color_id)
    end

    @projects = query.where(parent_id: @material.parent_id).all

    @samples = Sample.where(obj_id: @material.id).all
    @cases = Cases.limit(2)
  end
end
