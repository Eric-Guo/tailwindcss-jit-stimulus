# frozen_string_literal: true

class Area < ApplicationRecord
  has_many :cases, class_name: 'Cases'

  has_many :manufacturer_areas
  has_many :manufacturers, through: :manufacturer_areas

  has_many :material_product_areas
  has_many :material_products, through: :material_product_areas
end
