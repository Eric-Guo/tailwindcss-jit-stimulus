# frozen_string_literal: true

class ManufacturerContact < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :manufacturer_record
end