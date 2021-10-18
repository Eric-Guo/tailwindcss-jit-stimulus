# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  belongs_to :material
  belongs_to :color_system

  default_scope { where(deleted_at: nil) }
end
