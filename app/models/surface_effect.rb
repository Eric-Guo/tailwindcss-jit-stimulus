# frozen_string_literal: true

class SurfaceEffect < ApplicationRecord
  has_one :material_info
  has_many :samples

  has_many :material_product_surface_effects, primary_key: :surface_effect_id
  has_many :material_products, through: :material_product_surface_effects
end
