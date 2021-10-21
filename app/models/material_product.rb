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

  default_scope { where(deleted_at: nil) }

  def construction
    if practice_details.present?
      JSON.parse(practice_details)
    else
      []
    end
  end

  def files
    if source_file.present?
      JSON.parse(source_file)
    else
      []
    end
  end
  
  def texture
    if su_picture.present?
      JSON.parse(su_picture)
    else
      []
    end
  end
end
