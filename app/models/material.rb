# frozen_string_literal: true

class Material < ApplicationRecord
  self.table_name = 'materials'

  has_one :material_info
  has_one :material_product

  def color
    if level == 3
      material_product.color_system.description
    elsif level == 2
      material_info.color_system.description
    end
  end
end
