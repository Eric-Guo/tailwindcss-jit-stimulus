# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_many :samples

  has_many :material_manufacturers
  has_many :materials, through: :material_manufacturers

  default_scope { where(deleted_at: nil) }

  def self.sort_by_logo(sort = :desc)
    order(Arel.sql("CASE WHEN logo IS NULL THEN 0 WHEN logo = '' THEN 1 ELSE 2 END #{sort}"))
  end
end
