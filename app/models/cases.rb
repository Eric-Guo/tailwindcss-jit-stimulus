# frozen_string_literal: true

class Cases < ApplicationRecord
  self.table_name = 'cases'
  belongs_to :material, foreign_key: :obj_id, class_name: 'Material'

  def material
    if level == 3
      material_product.color_system
    elsif level == 2
      material_info.color_system.description
    end
  end
end
