# frozen_string_literal: true

class Material < ApplicationRecord
  has_one :material_info
  belongs_to :material, foreign_key: :parent_id
  has_one :material_product, foreign_key: :material_id, class_name: 'MaterialProduct'
  has_many :children_materials, class_name: :Material, foreign_key: :parent_id

  has_many :material_manufacturers
  has_many :manufacturers, through: :material_manufacturers

  has_many :case_materials, class_name: 'CasesMaterial'
  has_many :cases, through: :case_materials, class_name: 'Cases'

  has_many :samples, foreign_key: :obj_id

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
    color_system_ids = MaterialProductColorSystem.where(material_product_id: MaterialProduct.select(:id).where(material_id: material_ids)).pluck(:color_systems_id)
    ColorSystem.where(id: color_system_ids)
  end
end
