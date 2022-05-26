# frozen_string_literal: true

class CaseDelegateRecord < ApplicationRecord
  self.table_name = 'case_delegate_records'
  
  default_scope { where(deleted_at: nil) }

  belongs_to :delegate, class_name: 'CaseDelegate', foreign_key: :case_id, primary_key: :case_id

  def show_cover
    if web_cover != "" 
      File.join('images', web_cover)
    end
    if source_web_cover != "" 
      source_web_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    end
    "https://matlib.thape.com.cn/test/uploads/project_bg.png"
  end

end
