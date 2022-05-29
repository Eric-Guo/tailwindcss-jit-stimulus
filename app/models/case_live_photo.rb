# frozen_string_literal: true

class CaseLivePhoto < ApplicationRecord
  def show_cover
    if cover != "" 
      "https://matlib.thape.com.cn/test/" + cover
    elsif source_cover != "" 
      source_cover.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "https://matlib.thape.com.cn/test/uploads/project_bg.png"
    end
  end
  def show_path
    if path != "" 
      "https://matlib.thape.com.cn/test/" + path
    elsif source_path != "" 
      source_path.sub( "http://jzw.thape.com.cn/upload/", "https://matlib.thape.com.cn/jzw_image/" )
    else
      "https://matlib.thape.com.cn/test/uploads/project_bg.png"
    end
  end
end
