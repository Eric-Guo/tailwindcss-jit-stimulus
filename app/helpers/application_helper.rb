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

  def material_breadcrumbs(material, append_title: nil)
    breadcrumbs = [
      { title: '首页', url: '/' },
    ]
    if append_title.present?
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
        breadcrumbs.push({ title: append_title })
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

  def get_file_tag(url)
    ext = File.extname(url).downcase
    file_tags = [
      { name: 'pdf', exts: ['.pdf'], icon: 'icon-file-pdf.svg' },
      { name: 'doc', exts: ['.doc', '.docx', '.docm', '.dotx', '.dotm'], icon: 'icon-file-doc.svg' },
      { name: 'cad', exts: ['.dwg', '.dxf', '.dws', '.dwt'], icon: 'icon-file-cad.svg' },
      { name: 'ppt', exts: ['.pptx', '.ppsx', '.ppam', 'potx', '.thmx', '.ppsm'], icon: 'icon-file-ppt.svg' },
      { name: 'skp', exts: ['.skp'], icon: 'icon-file-skp.svg' },
      { name: 'xls', exts: ['.xlsx', '.xls', '.xlt', '.xlsm', '.xltm'], icon: 'icon-file-xls.svg' },
      { name: 'zip', exts: ['.zip', '.rar', '.gz', '.tar'], icon: 'icon-file-zip.svg' },
      { name: 'img', exts: ['.png', '.jpg', '.jpeg', '.svg'], icon: 'icon-file-img.svg' },
    ]
    file_tag = file_tags.detect { |item| item[:exts].include?(ext) }
    if file_tag.present?
      file_tag
    else
      { name: 'file', exts: [], icon: 'icon-file-file.svg' }
    end
  end
end
