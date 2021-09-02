module ApplicationHelper
  def mat_img_url(path, fallback_path)
    if path.present?
      "https://m-thtri.thape.com.cn/api/#{path}"
    else
      image_pack_path(fallback_path)
    end
  end
end
