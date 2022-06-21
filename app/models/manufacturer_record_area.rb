# frozen_string_literal: true

class ManufacturerRecordArea < ApplicationRecord
  belongs_to :manufacturer_record
  belongs_to :area
end
