# frozen_string_literal: true

class MaterialProductArea < ApplicationRecord
  belongs_to :material_product
  belongs_to :area, foreign_key: :area_id
end
