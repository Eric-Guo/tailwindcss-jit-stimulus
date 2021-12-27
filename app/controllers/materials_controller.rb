# frozen_string_literal: true

class MaterialsController < ApplicationController
  include ApplicationHelper

  def index
    @panel_name = params[:pn].presence
    @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(id: :asc)
    mat_ids = (params[:ms].presence || []).reject(&:blank?)
    @selected_mats = if mat_ids.present?
      Material.where(id: mat_ids)
    else
      Material.none
    end
    @selected_mat_parent_id = @selected_mats.collect(&:parent_id).first || 1

    @color_system = ColorSystem.find_by id: params[:color_system].presence
    @price_start = params[:price_start].presence
    @price_end = params[:price_end].presence

    @all_materials = Material.where(parent_id: @selected_mat_parent_id, display: 1, deleted_at: nil).order(id: :asc)
    @selected_all_materials = @all_materials.pluck(:id) == mat_ids.collect(&:to_i)
    @selected_none_materials = (@all_materials.pluck(:id) & mat_ids.collect(&:to_i)).blank?

    materila_with_query = if @q.present?
      mat_ids = q_return_mat_ids(@q)

      if mat_ids.present?
        Material.where(id: mat_ids)
      else
        Material.left_joins(:samples).includes(:samples).where('materials.level <> 1')
          .where('materials.name LIKE ? OR sample.genus LIKE ? OR sample.species LIKE ?', "%#{@q}%", "%#{@q}%", "%#{@q}%").distinct
      end
    else
      Material.where('materials.level <> 1')
    end

    materila_with_materials = if mat_ids.present?
      materila_with_query.where(id: mat_ids.append(@selected_mat_parent_id))
    else
      materila_with_query
    end

    materila_with_color_system = if @color_system.present?
      materila_with_materials.joins(material_product: :material_product_color_systems).where('material_product_color_systems.color_systems_id = ?', @color_system.id)
    else
      materila_with_materials
    end

    materila_with_price = if @price_start.present? && @price_end.present?
      materila_with_color_system.joins(:material_info).where('material_infos.high_price <= ?', @price_end).where('material_infos.low_price >= ?', @price_start)
    elsif @price_start.present?
      materila_with_color_system.joins(:material_info).where('material_infos.low_price >= ?', @price_start)
    elsif @price_end.present?
      materila_with_color_system.joins(:material_info).where('material_infos.high_price <= ?', @price_end)
    else
      materila_with_color_system
    end

    @materials = materila_with_price.limit(40)
  end

  def show
    @material = Material.find(params[:id])
    
    case @material.level
    when 1
      material = Material.where(grandpa_id: @material.id).first
      if material
        redirect_to material_path(material)
      else
        @projects = []
      end
    when 2
      material = Material.where(parent_id: @material.id).first
      if material
        redirect_to material_path(material)
      else
        @projects = []
      end
    when 3
      @color_id = params["color_id"]&.strip
      @projects = get_color_system_projects(@material, @color_id)
      unless @projects.pluck(:id).include?(@material.id)
        redirect_to material_path(@projects.first, request.GET)
      end
    end
  end

  def samples
    @material = Material.find(params[:id])
  end

  def color_system_list
    @material = Material.find(params[:id])
    @color_id = params['color_id']&.strip
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
        projects = projects.where(grandpa_id: material.id)
      when 2
        projects = projects.where(parent_id: material.id)
      when 3
        projects = projects.where(parent_id: material.parent_id)
      end
    end
end
