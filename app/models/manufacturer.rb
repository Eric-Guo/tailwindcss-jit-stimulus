# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  self.table_name = 'manufacturers'

  has_many :samples
end
