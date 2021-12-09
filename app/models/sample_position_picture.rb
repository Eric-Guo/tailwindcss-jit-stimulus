# frozen_string_literal: true

# frozen_string_literal: true SamplePositionPicture

class SamplePositionPicture < ApplicationRecord
  default_scope { where(deleted_at: nil) }
end
