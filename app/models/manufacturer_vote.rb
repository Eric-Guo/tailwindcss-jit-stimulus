# frozen_string_literal: true

class ManufacturerVote < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :user

  default_scope { where(deleted_at: nil) }
end
