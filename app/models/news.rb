# frozen_string_literal: true

class News < ApplicationRecord
  default_scope { where(deleted_at: nil).where(display: 1) }
end
