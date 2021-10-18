# frozen_string_literal: true

class SampleSurfaceEffect < ApplicationRecord
  belongs_to :sample
  belongs_to :surface_effect, foreign_key: :surface_effect_id
end
