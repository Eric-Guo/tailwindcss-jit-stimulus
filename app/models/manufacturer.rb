# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_many :samples
end
