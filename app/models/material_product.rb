# frozen_string_literal: true

class MaterialProduct < ApplicationRecord
  belongs_to :material
  belongs_to :color_system

  has_many :material_product_color_systems
  has_many :color_systems, through: :material_product_color_systems

  has_many :material_product_surface_effects
  has_many :surface_effects, through: :material_product_surface_effects

  has_many :material_product_practical_applications
  has_many :practical_applications, through: :material_product_practical_applications
end
