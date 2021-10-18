# frozen_string_literal: true

# frozen_string_literal: true SampleEnclosure

class ColorSystem < ApplicationRecord
  has_many :material_product_color_systems, primary_key: :color_systems_id
  has_many :material_products, through: :material_product_color_system

  has_many :sample_color_systems, primary_key: :color_systems_id
  has_many :samples, through: :sample_color_systems

  default_scope { where(deleted_at: nil) }
end
