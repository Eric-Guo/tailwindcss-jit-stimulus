# frozen_string_literal: true

class Material < ApplicationRecord
  has_one :material_info
  belongs_to :parent_material, foreign_key: :parent_id, class_name: 'Material', optional: true
  belongs_to :grandpa_material, foreign_key: :grandpa_id, class_name: 'Material', optional: true
  has_one :material_product, foreign_key: :material_id, class_name: 'MaterialProduct'
  has_many :children_materials, class_name: :Material, foreign_key: :parent_id
  has_many :grandpa_materials, class_name: :Material, foreign_key: :grandpa_id

  has_many :material_manufacturers
  has_many :manufacturers, through: :material_manufacturers

  has_many :case_materials, class_name: 'CasesMaterial'
  has_many :cases, through: :case_materials, class_name: 'Cases'

  has_many :samples, foreign_key: :obj_id

  default_scope { where(deleted_at: nil).where(display: 1) }

  def color
    material_product&.color_systems&.pluck(:description)&.join(',')
  end

  def parent_color_systems
    material_ids = case level
      when 1
        grandpa_materials.pluck(:id)
      when 2
        children_materials.pluck(:id)
      when 3
        parent_material.children_materials.pluck(:id)
      else
        raise ActiveRecord::ActiveRecordError.new("不存在的材料级别: #{level}")
      end
    color_system_ids = MaterialProductColorSystem.where(material_product_id: MaterialProduct.select(:id).where(material_id: material_ids)).pluck(:color_systems_id)
    ColorSystem.where(id: color_system_ids)
  end
end
