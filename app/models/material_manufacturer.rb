# frozen_string_literal: true

class MaterialManufacturer < ApplicationRecord
  belongs_to :material
  belongs_to :manufacturer, foreign_key: :manufacturer_id
end