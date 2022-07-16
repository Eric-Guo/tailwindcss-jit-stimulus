# frozen_string_literal: true

class CaseDelegateRecord < ApplicationRecord
  include ApplicationHelper

  self.table_name = 'case_delegate_records'
  default_scope { where(deleted_at: nil) }

  has_many :case_materials, class_name: 'CasesMaterial', foreign_key: :case_delegate_record_id
  has_many :materials, through: :case_materials

  has_many :case_material_samples, through: :case_materials
  has_many :samples, through: :case_material_samples

  belongs_to :area, optional: true

  has_many :case_record_live_photos, foreign_key: :case_delegate_record_id
  has_many :live_photos, class_name: 'CaseLivePhoto', through: :case_record_live_photos, source: :live_photo

  has_many :case_record_relevant_document, foreign_key: :case_delegate_record_id
  has_many :documents, class_name: 'CaseRelevantDocument', through: :case_record_relevant_document, source: :document

  has_many :case_record_lmkzscs, foreign_key: :case_delegate_record_id
  has_many :lmkzscs, through: :case_record_lmkzscs, source: :lmkzsc

  has_one :delegate, class_name: 'CaseDelegate', foreign_key: :case_delegate_record_id

  def project_name_and_location
    [self.project_name, self.project_location&.gsub('上海市','')].select { |str| str.present? }.join('/')
  end

  def material_tags
    @material_tags ||= materials.limit(3).pluck(:name)
  end

  def show_cover
    if web_cover != "" 
      matlib_file_path_prefix + web_cover
    elsif source_web_cover != "" 
      source_web_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "#{matlib_file_path_prefix}uploads/project_bg.png"
    end
  end

  # 立面控制手册
  def facade
    lmkzscs.map do |item|
      file_tag = get_file_tag(item.path)
      {
        tag_name: file_tag[:name],
        tag_icon: file_tag[:icon],
        name: item.name,
        url: item.path,
      }
    end
  end

  # 相关文件
  def related_files
    documents.select { |item| item.path.present? }.map do |item|
      file_tag = get_file_tag(item.path)
      {
        tag_name: file_tag[:name],
        tag_icon: file_tag[:icon],
        name: item.title,
        url: item.path,
      }
    end
  end

  # 详情链接
  def detail_url
    return jzw_url if (is_th == true || is_th == 1) && (zz_online_id == 0 || zz_online_id == nil)
    nil
  end

  # 是否天华案例
  def is_th_str
    if is_th == true || is_th == 1
      '内部案例'
    else
      '外部案例'
    end
  end

  # 项目地区
  def project_location
    area&.title
  end
end
