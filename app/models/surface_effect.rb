# frozen_string_literal: true

class SurfaceEffect < ApplicationRecord
  has_one :material_info
  has_many :samples
end
