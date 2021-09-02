# frozen_string_literal: true

class MaterialProduct < ApplicationRecord
  self.table_name = 'material_products'

  belongs_to :material
  belongs_to :color_system
end
