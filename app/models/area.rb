# frozen_string_literal: true

class Area < ApplicationRecord
  has_many :cases, class_name: 'Cases'
end
