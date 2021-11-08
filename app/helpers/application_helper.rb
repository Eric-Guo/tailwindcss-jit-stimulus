# frozen_string_literal: true

module ApplicationHelper
  def mat_img_url(path, fallback_path = '')
    if path.present?
      "https://matlib.thape.com.cn/#{path}"
    elsif fallback_path.present?
      image_pack_path(fallback_path)
    else
      ''
    end
  end

  def get_first_url(paths)
    if paths.class == Array
      "https://matlib.thape.com.cn/#{paths[0]}"
    else
      begin
          paths = JSON.parse(paths)
          "https://matlib.thape.com.cn/#{paths[0]}"
      rescue JSON::ParserError
        # Handle error
      end
    end

  end

  def material_breadcrumbs(material, in_samples: false)
    breadcrumbs = [
      { title: '首页', url: '/' },
    ]
    if in_samples
      case material.level
      when 1
        breadcrumbs.push({ title: material.name, url: material_path(material.parent_material) })
      when 2
        breadcrumbs.push({ title: material.parent_material.name, url: material_path(material.parent_material) })
        breadcrumbs.push({ title: material.name, url: material_path(material.parent_material) })
      when 3
        breadcrumbs.push({ title: material.grandpa_material.name, url: material_path(material.grandpa_material) })
        breadcrumbs.push({ title: material.parent_material.name, url: material_path(material.parent_material) })
        breadcrumbs.push({ title: material.name, url: material_path(material) })
        breadcrumbs.push({ title: '相关列表' })
      end
    else
      case material.level
      when 1
        breadcrumbs.push({ title: material.name })
      when 2
        breadcrumbs.push({ title: material.parent_material.name, url: material_path(material.parent_material) })
        breadcrumbs.push({ title: material.name })
      when 3
        breadcrumbs.push({ title: material.grandpa_material.name, url: material_path(material.grandpa_material) })
        breadcrumbs.push({ title: material.parent_material.name, url: material_path(material.parent_material) })
        breadcrumbs.push({ title: material.name })
      end
    end
  end
end
