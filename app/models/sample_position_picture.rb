# frozen_string_literal: true

class SamplePositionPicture < ApplicationRecord
  default_scope { where(deleted_at: nil) }
end
