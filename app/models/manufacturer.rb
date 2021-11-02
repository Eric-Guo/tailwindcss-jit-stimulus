# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_many :samples

  has_many :material_manufacturers
  has_many :materials, through: :material_manufacturers

  default_scope { where(deleted_at: nil) }
end
