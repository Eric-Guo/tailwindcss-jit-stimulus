# frozen_string_literal: true

class MaterialProduct < ApplicationRecord
  self.table_name = 'material_products'

  belongs_to :material
  belongs_to :color_system
  has_many :material_product_color_systems
  has_many :color_systems, through: :material_product_color_systems,foreign_key: :color_systems_id
end
