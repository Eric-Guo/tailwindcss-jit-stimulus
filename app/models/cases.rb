# frozen_string_literal: true

class Cases < ApplicationRecord
  include ApplicationHelper

  self.table_name = 'cases'

  has_many :case_materials, class_name: 'CasesMaterial', foreign_key: :case_id
  has_many :materials, through: :case_materials

  has_many :case_material_samples, through: :case_materials
  has_many :samples, through: :case_material_samples

  belongs_to :area, optional: true

  has_many :case_many_live_photos, foreign_key: :cases_id
  has_many :live_photos, class_name: 'CaseLivePhoto', through: :case_many_live_photos, source: :live_photo

  has_many :case_many_relevant_document, foreign_key: :cases_id
  has_many :documents, class_name: 'CaseRelevantDocument', through: :case_many_relevant_document, source: :document

  has_many :case_lmkzscs, foreign_key: :cases_id
  has_many :lmkzscs, through: :case_lmkzscs, source: :lmkzsc

  has_many :case_manufacturers, foreign_key: :cases_id
  
  default_scope { where(deleted_at: nil).where(display: 1).where(status: 'case_published') }

  def project_name_and_location
    [self.project_name, self.project_location&.gsub('上海市','')].select { |str| str.present? }.join('/')
  end

  def material_tags
    @material_tags ||= materials.limit(3).pluck(:name)
  end

  def self.project_locations
    @project_locations ||= all.joins(:area)
      .where('areas.area_id = 0')
      .order('area_id')
      .distinct
      .select('areas.title area_title', 'area_id')
  end

  def self.project_types
    %w[公建 住宅]
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

  # 项目地区
  def project_location
    area&.title
  end

  # 是否天华项目
  def is_th_str
    if is_th == true || is_th == 1
      '内部项目'
    else
      '外部项目'
    end
  end

  # 是否在保密时间内
  def in_secret_time?
    visibility == 2 && end_visibility_at > Time.now()
  end

  # 用户可以查看案例的权限
  def permissions(current_user)
    show_detail = current_user&.super_staff?.present? || \
    (
      current_user&.main_position.present? \
      && Position.architecture?(current_user.main_position.b_postcode) \
      && (in_secret_time? ? current_user.main_position.post_level.to_i > 11 : true)
    )
    @_permissions ||= {
      base: true, # 基础信息，项目列表
      info: show_detail, # 全部信息，包括案例信息与材料信息
      facade_manual: show_detail, # 立面手册
      related_files: show_detail && current_user.main_position.post_level.to_i > 8, # 其他文件
      download_file_count: if show_detail && current_user.main_position.post_level.to_i > 11
        9999
      elsif show_detail && (9..11) === current_user.main_position.post_level.to_i
        3
      elsif show_detail
        1
      else
        0
      end,
    }
  end
end
