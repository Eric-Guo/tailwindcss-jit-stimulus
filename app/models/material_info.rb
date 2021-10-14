# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  belongs_to :material
  belongs_to :color_system
end
