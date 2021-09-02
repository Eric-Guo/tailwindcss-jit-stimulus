# frozen_string_literal: true

class SurfaceEffect < ApplicationRecord
  self.table_name = 'surface_effects'

  has_one :material_info
  has_many :samples
end
