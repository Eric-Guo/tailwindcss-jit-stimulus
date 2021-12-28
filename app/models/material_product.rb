# frozen_string_literal: true

class MaterialProduct < ApplicationRecord
  belongs_to :material
  belongs_to :color_system

  has_many :material_product_color_systems
  has_many :color_systems, through: :material_product_color_systems

  has_many :material_product_surface_effects
  has_many :surface_effects, through: :material_product_surface_effects

  has_many :material_product_areas
  has_many :areas, through: :material_product_areas

  default_scope { where(deleted_at: nil) }

  def self.material_product_locations
    @material_product_locations ||= all.joins(:areas)
      .distinct
      .pluck('areas.title area_title', 'material_product_areas.area_id')
  end

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

  def practical_applications_json
    arr = self.practical_applications.is_a?(String) ? JSON.parse(self.practical_applications) : self.practical_applications
    if arr.present? && arr.is_a?(Array)
      arr.map { |item| item.with_indifferent_access }
    else
      []
    end
  end
end
