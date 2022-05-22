# frozen_string_literal: true

class CaseDelegate < ApplicationRecord
  self.table_name = 'case_delegates'

  default_scope { where(deleted_at: nil) }

  has_one :record, class_name: 'CaseDelegateRecord', foreign_key: :case_id, primary_key: :case_id

  def self.status_hash
    {
      delegate_uploading: '待上传',
      delegate_improving: '待完善',
      delegate_reviewing: '审核中',
      delegate_publishing: '待上架',
      delegate_published: '已上架',
      delegate_unpublishing: '待下架',
      delegate_unpublish_reviewing: '审核中',
      delegate_unpublished: '已下架',
    }
  end

  def status_name
    CaseDelegate.status_hash[status.to_sym]
  end

end
