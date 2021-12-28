# frozen_string_literal: true

class ManufacturerArea < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :area
end
