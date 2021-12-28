# frozen_string_literal: true

class News < ApplicationRecord
  has_many :news_materials
  has_many :materials, through: :news_materials
  default_scope { where(deleted_at: nil).where(display: 1) }
end
