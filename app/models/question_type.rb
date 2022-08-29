# frozen_string_literal: true

class QuestionType < ApplicationRecord
  default_scope { where(deleted_at: nil) }
end
