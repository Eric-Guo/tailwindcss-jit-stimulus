# frozen_string_literal: true

class CaseLivePhoto < ApplicationRecord
  include ApplicationHelper

  has_many :tags, class_name: "CaseLivePhotoTag", foreign_key: "case_live_photo_id"

  def show_cover
    if cover.present?
      matlib_file_path_prefix + cover
    elsif source_cover.present?
      source_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "#{matlib_file_path_prefix}uploads/project_bg.png"
    end
  end

  def show_path
    if path.present?
      matlib_file_path_prefix + path
    elsif source_path.present?
      source_path.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "#{matlib_file_path_prefix}uploads/project_bg.png"
    end
  end
end
