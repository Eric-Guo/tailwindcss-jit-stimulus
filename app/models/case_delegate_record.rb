# frozen_string_literal: true

class CaseDelegateRecord < ApplicationRecord
  self.table_name = 'case_delegate_records'
  default_scope { where(deleted_at: nil) }

  has_many :case_materials, -> { joins(:material).where(type_id: 2) }, class_name: 'CasesMaterial', foreign_key: :case_delegate_record_id
  has_many :case_samples, -> { where(type_id: 1) }, class_name: 'CasesMaterial', foreign_key: :case_delegate_record_id
  has_many :materials, through: :case_materials
  has_many :samples, through: :case_samples
  belongs_to :area, optional: true

  has_many :live_photos, class_name: 'CaseLivePhoto', foreign_key: :case_delegate_record_id


  belongs_to :delegate, class_name: 'CaseDelegate', foreign_key: :case_id, primary_key: :case_id

  def project_name_and_location
    [self.project_name, self.project_location&.gsub('上海市','')].select { |str| str.present? }.join('/')
  end

  def material_tags
    @material_tags ||= materials.limit(3).pluck(:name)
  end

  def show_cover
    if web_cover != "" 
      "https://matlib.thape.com.cn/test/" + web_cover
    elsif source_web_cover != "" 
      source_web_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "https://matlib.thape.com.cn/test/uploads/project_bg.png"
    end
  end

  # 详情链接
  def detail_url
    return jzw_url if is_th && (zz_online_id == 0 || zz_online_id == nil)
    nil
  end

  # 是否天华案例
  def is_th_str
    if is_th
      '内部案例'
    else
      '外部案例'
    end
  end
end
