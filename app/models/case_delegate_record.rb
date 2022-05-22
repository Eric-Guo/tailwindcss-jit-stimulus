# frozen_string_literal: true

class CaseDelegateRecord < ApplicationRecord
  self.table_name = 'case_delegate_records'
  
  default_scope { where(deleted_at: nil) }

  belongs_to :delegate, class_name: 'CaseDelegate', foreign_key: :case_id, primary_key: :case_id

  def show_cover
    c = web_cover.presence || source_cover.presence
    c && File.join('images', c)
  end

end
