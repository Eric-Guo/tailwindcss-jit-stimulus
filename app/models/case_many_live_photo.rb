# frozen_string_literal: true

class CaseManyLivePhoto < ApplicationRecord
  belongs_to :project, class_name: 'Cases', foreign_key: :cases_id
  belongs_to :live_photo, class_name: 'CaseLivePhoto', foreign_key: :case_live_photo_id
end
