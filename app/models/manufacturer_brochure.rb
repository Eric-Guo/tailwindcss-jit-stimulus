# frozen_string_literal: true

class ManufacturerBrochure < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :manufacturer_record
end