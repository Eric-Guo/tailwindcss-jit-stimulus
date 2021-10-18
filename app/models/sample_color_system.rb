# frozen_string_literal: true

class SampleColorSystem < ApplicationRecord
  belongs_to :sample
  belongs_to :color_system, foreign_key: :color_systems_id
end
