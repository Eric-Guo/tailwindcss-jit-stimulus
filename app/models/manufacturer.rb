# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_many :samples

  has_many :material_manufacturers, primary_key: :manufacturer_id
  has_many :manufacturers, through: :material_manufacturers
end
