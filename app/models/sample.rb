# frozen_string_literal: true

class Sample < ApplicationRecord
  self.table_name = 'sample'

  belongs_to :material, foreign_key: :obj_id, class_name: 'Material'
  belongs_to :surface_effect
  belongs_to :manufacturer
  has_many :sample_enclosures

  has_many :sample_color_systems
  has_many :color_systems, through: :sample_color_systems

  has_many :sample_surface_effects
  has_many :surface_effects, through: :sample_surface_effects
  
  belongs_to :sample_position_picture

  default_scope { where(deleted_at: nil).where(display: 1) }

  def color_str
    self.color_systems&.collect(&:description)&.join(',')
  end

  # 表面效果描述
  def surface_effect_descriptions
    @_surface_effect_descriptions ||= if self.surface_effects.present?
      self.surface_effects.pluck(:description).join('、')
    else
      self.aq_vein
    end
  end
end
