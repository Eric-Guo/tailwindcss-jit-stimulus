# frozen_string_literal: true

class QualityControl < ApplicationRecord
  belongs_to :material

  default_scope { where(deleted_at: nil) }
end
