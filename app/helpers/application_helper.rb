# frozen_string_literal: true

module ApplicationHelper
  def matlib_file_path_prefix
    Rails.application.credentials.matlib_file_path_prefix!
  end

  def user_image_url(user)
    return if user&.clerk_code.blank?
    hash = Digest::MD5.hexdigest(user.clerk_code + 'af8f0885aa412d7923855')
    "https://portal.thape.com.cn/uploads/wcavatars/#{hash}.jpg"
  end

  def mat_img_url(path, fallback_path = '')
    if path.present?
      "#{matlib_file_path_prefix}#{path}"
    elsif fallback_path.present?
      image_pack_path(fallback_path)
    else
      ''
    end
  end

  def preview_mat_pdf_url(path)
    return nil unless path.present?
    file_url = URI.encode_www_form_component("#{matlib_file_path_prefix}#{path}")
    "/pdfjs/web/viewer.html?file=#{file_url}"
  end

  def get_first_url(paths)
    if paths.class == Array
      "#{matlib_file_path_prefix}#{paths[0]}"
    else
      begin
          paths = JSON.parse(paths)
          "#{matlib_file_path_prefix}#{paths[0]}"
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
      { name: 'pdf', exts: ['.pdf'], icon: 'static/images/icon-file-pdf.svg' },
      { name: 'doc', exts: ['.doc', '.docx', '.docm', '.dotx', '.dotm'], icon: 'static/images/icon-file-doc.svg' },
      { name: 'cad', exts: ['.dwg', '.dxf', '.dws', '.dwt'], icon: 'static/images/icon-file-cad.svg' },
      { name: 'ppt', exts: ['.pptx', '.ppsx', '.ppam', 'potx', '.thmx', '.ppsm'], icon: 'static/images/icon-file-ppt.svg' },
      { name: 'skp', exts: ['.skp'], icon: 'static/images/icon-file-skp.svg' },
      { name: 'xls', exts: ['.xlsx', '.xls', '.xlt', '.xlsm', '.xltm'], icon: 'static/images/icon-file-xls.svg' },
      { name: 'zip', exts: ['.zip', '.rar', '.gz', '.tar'], icon: 'static/images/icon-file-zip.svg' },
      { name: 'img', exts: ['.png', '.jpg', '.jpeg', '.svg'], icon: 'static/images/icon-file-img.svg' },
    ]
    file_tag = file_tags.detect { |item| item[:exts].include?(ext) }
    if file_tag.present?
      file_tag
    else
      { name: 'file', exts: [], icon: 'static/images/icon-file-file.svg' }
    end
  end

  def text_with_default(text)
    text.present? ? text : '—'
  end

  def vuex_json()
    return { user: nil }.to_json if current_user.blank?

    {
      user: {
        userInfo: {
          nickName: current_user.chinese_name,
          headerImg: user_image_url(current_user),
          authority: '',
          id: current_user.id
        },
        adminToken: JWT.encode({ sub: current_user.email, scp: 'user', aud: 'matlib', iat: Time.now.to_i, exp: 1.hour.after.to_i }, Rails.application.credentials.devise_jwt_secret_key!),
        host: 'm-thtri.thape.com.cn'
      }
    }.to_json
  end

  def markdown(text)       
    options = {              
      :autolink => true,            
      :space_after_headers => true,           
      :fenced_code_blocks => true,           
      :no_intra_emphasis => true,           
      :hard_wrap => true,           
      :strikethrough =>true         
      }       
    markdown = Redcarpet::Markdown.new(HTMLWithCodeRay, options)
    markdown.render(h(text)).html_safe
  end

  def url_options
    {
      host: request.host,
      protocol: request.scheme,
      port: request.port,
    }
  end

  def static_file_url(url)
    return nil unless url.present?
    prefix = if url_options.present?
      Rails.application.routes.url_helpers.root_url(**url_options)
    else
      Rails.application.routes.url_helpers.root_path
    end
    URI.join(prefix, url).to_s
  end
end
