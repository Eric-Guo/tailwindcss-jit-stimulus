# frozen_string_literal: true

class Material < ApplicationRecord
  # 二级对应的产品
  has_one :material_info, foreign_key: :material_id, class_name: 'MaterialInfo'

  # 三级对应的产品
  has_one :material_product, foreign_key: :material_id, class_name: 'MaterialProduct'
  
  # 父级
  belongs_to :parent_material, foreign_key: :parent_id, class_name: 'Material', optional: true

  # 祖父级
  belongs_to :grandpa_material, foreign_key: :grandpa_id, class_name: 'Material', optional: true

  # 子级
  has_many :children_materials, class_name: :Material, foreign_key: :parent_id

  # 孙子级
  has_many :grandpa_materials, class_name: :Material, foreign_key: :grandpa_id

  # 厂家信息
  has_many :material_manufacturers
  has_many :manufacturers, through: :material_manufacturers

  # 案例
  has_many :case_materials, class_name: 'CasesMaterial'
  has_many :cases, through: :case_materials, class_name: 'Cases'

  # 样品
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

  # 安装施工要点
  def installation_and_construction_points
    @_installation_and_construction_points ||= if level == 3 && material_product&.points.present?
      material_product.points
    elsif level == 3 && parent_material.material_info&.points.present?
      parent_material.material_info.points
    else
      nil
    end
  end

  # 可定制效果
  def customizable_effect
    @_customizable_effect ||= material_product&.customized
  end
end
