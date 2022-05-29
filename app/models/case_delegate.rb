# frozen_string_literal: true

class CaseDelegate < ApplicationRecord
  self.table_name = 'case_delegates'

  default_scope { where(deleted_at: nil).where(closed_at: nil) }

  has_one :record, class_name: 'CaseDelegateRecord', foreign_key: :id, primary_key: :case_delegate_record_id

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

  def self.web_status_hash
    {
      '0': {
        names: ['delegate_uploading'],
        title: '待上传',
      },
      '1': {
        names: ['delegate_improving'],
        title: '待完善',
      },
      '2': {
        names: ['delegate_reviewing', 'delegate_unpublish_reviewing'],
        title: '审核中',
      },
      '3': {
        names: ['delegate_publishing'],
        title: '待上架',
      },
      '4': {
        names: ['delegate_published'],
        title: '已上架',
      },
      '5': {
        names: ['delegate_unpublishing'],
        title: '待下架',
      },
      '6': {
        names: ['delegate_unpublished'],
        title: '已下架',
      },
    }
  end

  def status_name
    CaseDelegate.status_hash[status.to_sym]
  end

  def web_status_title
    s = CaseDelegate.web_status_hash.to_a.detect { |item| item[1][:names].include?(status) }
    s && s[1][:title]
  end
end
