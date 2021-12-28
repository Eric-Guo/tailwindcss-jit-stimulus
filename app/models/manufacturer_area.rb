# frozen_string_literal: true

class ManufacturerArea < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :area, foreign_key: :area_id
end
