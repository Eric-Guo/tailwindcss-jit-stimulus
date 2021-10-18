# frozen_string_literal: true

class Sample < ApplicationRecord
  self.table_name = 'sample'

  belongs_to :material, foreign_key: :obj_id, class_name: 'Material'
  belongs_to :surface_effect
  belongs_to :manufacturer
  has_many :SampleEnclosures, foreign_key: :id, class_name: 'SampleEnclosure'

  has_many :sample_color_systems
  has_many :color_systems, through: :sample_color_systems

  has_many :sample_surface_effects
  has_many :surface_effects, through: :sample_surface_effects

  default_scope { where(deleted_at: nil) }
end
