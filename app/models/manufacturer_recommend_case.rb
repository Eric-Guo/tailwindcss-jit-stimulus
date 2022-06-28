# frozen_string_literal: true

class ManufacturerRecommendCase < ApplicationRecord
  belongs_to :manufacturer_recommend
  has_many :live_photos, class_name: 'MrCaseLivePhoto'

  default_scope { where(deleted_at: nil) }
end
