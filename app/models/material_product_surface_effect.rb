# frozen_string_literal: true

class MaterialProductSurfaceEffect < ApplicationRecord
  belongs_to :material_product
  belongs_to :surface_effect, foreign_key: :surface_effect_id
end
