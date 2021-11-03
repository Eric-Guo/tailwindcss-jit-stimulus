# frozen_string_literal: true

class MaterialsController < ApplicationController
  include ApplicationHelper
  
  def show
    @material = Material.find(params[:id])

    @color_id = params["color_id"]&.strip
    @projects = get_color_system_projects(@material, @color_id)
  end

  def color_system_list
    @material = Material.find(params[:id])
    @color_id = params["color_id"]&.strip
    @projects = get_color_system_projects(@material, @color_id)
  end

  # 材质贴图下载
  def download_texture
    material = Material.find(params[:id])

    if material.level == 3
      filename = "#{material.name}-材质贴图.zip"
      temp_file = Tempfile.new(filename)

      images = material.material_product.texture.map do |item|
        url = mat_img_url(item[:url], "2")
        name = Pathname.new(url).basename.to_s
        { name: name, url: url }
      end

      begin
        Zip::OutputStream.open(temp_file) { |zos| }
        Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
          images.each do |image|
            response = HTTP.get(image[:url])
            if response.status.success?
              image_temp_file = Tempfile.new(image[:name])
              image_temp_file.write(response.body.to_s.force_encoding(Encoding::UTF_8))
              zipfile.add(image[:name], image_temp_file.path)
            end
          end
        end

        zip_data = File.read(temp_file.path)
        send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename: filename)
      ensure
        temp_file.close
        temp_file.unlink
      end
    else
      render html: "<h1>无法下载</h1>".html_safe
    end
  end

  private
    def get_color_system_projects(material, color_id = nil)
      projects = Material.joins(:material_product)

      if color_id.present?
        projects = projects.where(material_product: { id: MaterialProductColorSystem.select(:material_product_id).where(color_systems_id: color_id) })
      end
    
      case material.level
      when 1
        projects = projects.where(parent_id: Material.select(:id).where(parent_id: material.id))
      when 2
        projects = projects.where(parent_id: material.id)
      when 3
        projects = projects.where(parent_id: material.parent_id)
      end
      projects.sort_by { |item| item.id == material.id ? -1 : 0 }
    end
end
