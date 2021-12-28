# frozen_string_literal: true

class NewsMaterial < ApplicationRecord
  belongs_to :news
  belongs_to :material
end
