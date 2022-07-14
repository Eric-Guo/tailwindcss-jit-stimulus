# frozen_string_literal: true

class CaseLivePhoto < ApplicationRecord
  include ApplicationHelper

  def show_cover
    if cover != "" 
      matlib_file_path_prefix + cover
    elsif source_cover != "" 
      source_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "#{matlib_file_path_prefix}uploads/project_bg.png"
    end
  end
  def show_path
    if path != "" 
      matlib_file_path_prefix + path
    elsif source_path != "" 
      source_path.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "#{matlib_file_path_prefix}uploads/project_bg.png"
    end
  end
end
