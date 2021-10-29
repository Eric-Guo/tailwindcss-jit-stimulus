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
      if practice_details.is_a?(Array)
        practice_details
      else
        data = JSON.parse(practice_details)
        data.is_a?(Array) ? data : []
      end
    else
      []
    end.map { |item| item.with_indifferent_access }
  end

  def files
    if source_file.present?
      data = JSON.parse(source_file)
      data.is_a?(Array) ? data : []
    else
      []
    end.map { |item| item.with_indifferent_access }
  end
  
  def texture
    if su_picture.present?
      data = JSON.parse(su_picture)
      data.is_a?(Array) ? data : []
    else
      []
    end.map { |item| item.with_indifferent_access }
  end
end
