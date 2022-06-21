# frozen_string_literal: true

class MaterialManufacturerRecord < ApplicationRecord
  self.table_name = 'material_manufacturer_record'

  belongs_to :material
  belongs_to :manufacturer_record, foreign_key: :manufacturer_record_id
end