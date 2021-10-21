# frozen_string_literal: true

class Cases < ApplicationRecord
  self.table_name = 'cases'
  has_many :case_materials, class_name: 'CasesMaterial'

  default_scope { where(deleted_at: nil) }

  def material
    if level == 3
      material_product.color_system
    elsif level == 2
      material_info.color_system.description
    end
  end
end
