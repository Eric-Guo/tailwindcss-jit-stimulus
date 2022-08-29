# frozen_string_literal: true

class ManufacturerFeedbackReply < ApplicationRecord
  belongs_to :manufacturer_feedback

  default_scope { where(deleted_at: nil) }
end
