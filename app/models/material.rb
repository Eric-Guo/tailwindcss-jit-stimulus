# frozen_string_literal: true

class Material < ApplicationRecord
  has_one :material_info
  belongs_to :material, foreign_key: :parent_id
  has_one :material_product, foreign_key: :material_id, class_name: 'MaterialProduct'
  has_many :children_materials, class_name: :Material, foreign_key: :parent_id

  has_many :material_manufacturers
  has_many :manufacturers, through: :material_manufacturers

  default_scope { where(deleted_at: nil).where(display: 1) }

  def color
    if level == 3
      material_product.color_system
    elsif level == 2
      material_info.color_system.description
    end
  end

  def parent_material
    case level
    when 3
      Material.find_by(id: parent_id)
    when 2
      self
    end
  end

  def parent_color_systems
    material_ids = parent_material.children_materials.pluck(:id)
    ColorSystem.where(id: MaterialProduct.select(:color_system_id).where(material_id: material_ids))
  end
end
