# frozen_string_literal: true

class ManufacturerRecommend < ApplicationRecord
  belongs_to :material
  has_many :cases, class_name: 'ManufacturerRecommendCase'
  belongs_to :manufacturer

  default_scope { where(deleted_at: nil) }

  def is_th_co_text
    is_th_co ? '是' : '否'
  end

  def to_manufacturer?
    status == 'manufacturer_recommend_approved' && manufacturer.present?
  end
end
