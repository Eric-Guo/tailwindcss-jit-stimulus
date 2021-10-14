# frozen_string_literal: true

class MaterialProductColorSystem < ApplicationRecord
  belongs_to :material_product,foreign_key: :color_systems_id
  belongs_to :color_system,foreign_key: :color_systems_id
end
