# frozen_string_literal: true

class ManufacturerVote < ApplicationRecord
  belongs_to :manufacturer, foreign_key: :manufactor_id
  belongs_to :user

  default_scope { where(deleted_at: nil) }
end
