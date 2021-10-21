# frozen_string_literal: true

class MaterialsController < ApplicationController
  def show
    @material = Material.find_by!(id: params[:id])

    @color_id = params["color_id"]&.strip
    @projects = get_color_system_projects(@material, @color_id)
  end

  def color_system_list
    @material = Material.find(params[:id])
    @color_id = params["color_id"]&.strip
    @projects = get_color_system_projects(@material, @color_id)
  end

  private
    def get_color_system_projects(material, color_id = nil)
      projects = Material.joins(:material_product)

      if color_id.present?
        projects = projects.where(material_product: { id: MaterialProductColorSystem.select(:material_product_id).where(color_systems_id: color_id) })
      end
    
      case material.level
      when 1
        projects = projects.where(parent_id: Material.select(:id).where(parent_id: material.id))
      when 2
        projects = projects.where(parent_id: material.id)
      when 3
        projects = projects.where(parent_id: material.parent_id)
      end
      projects
    end
end
