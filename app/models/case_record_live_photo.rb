# frozen_string_literal: true

class CaseRecordLivePhoto < ApplicationRecord
  belongs_to :project, class_name: 'CaseDelegateRecord', foreign_key: :case_delegate_record_id
  belongs_to :live_photo, class_name: 'CaseLivePhoto', foreign_key: :case_live_photo_id
end
