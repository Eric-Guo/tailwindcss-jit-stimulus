# frozen_string_literal: true

module ApplicationHelper
  def mat_img_url(path, fallback_path)
    if path.present?
      "https://m-thtri.thape.com.cn/api/#{path}"
    else
      image_pack_path(fallback_path)
    end
  end

  def get_first_url(paths)
    if paths.class == Array
      "https://m-thtri.thape.com.cn/api/#{paths[0]}"
    else
      begin
          paths = JSON.parse(paths)
          "https://m-thtri.thape.com.cn/api/#{paths[0]}"
      rescue JSON::ParserError
        # Handle error
      end
    end

  end
end
