# frozen_string_literal: true

class MrCaseLivePhoto < ApplicationRecord
  belongs_to :manufacturer_recommend_case

  default_scope { where(deleted_at: nil) }
end
