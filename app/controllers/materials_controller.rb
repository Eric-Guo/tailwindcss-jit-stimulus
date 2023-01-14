# frozen_string_literal: true

class MaterialsController < ApplicationController
  include ApplicationHelper
  before_action only: [:index], if: -> { request.variant.include?(:phone) } do
    redirect_to '/m/materials'
  end
  before_action only: [:show], if: -> { request.variant.include?(:phone) } do
    redirect_to "/m/materials/#{params[:id]}"
  end
  before_action :authenticate_user!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def index
    if turbo_frame_request?
      @page_size_options = [24, 32, 48, 72, 104]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

      mat_ids = (params[:ms].presence || []).reject(&:blank?).collect(&:to_i)

      @color_system = ColorSystem.find_by id: params[:color_system].presence

      @price_start = params[:price_start].presence&.to_f
      @price_end = params[:price_end].presence&.to_f

      @area_id = params[:area_id].presence

      @list = MaterialAndSample.where.not(material_level: 1).order(material_no: :asc, sample_id: :asc)

      # 关键词
      if @q.present?
        @list = @list.where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{@q}%")
      end

      # 材料筛选
      if mat_ids.present?
        @list = @list.where('material_id IN (:ids) OR parent_material_id IN (:ids)', ids: mat_ids)
      end

      # 色系
      if @color_system.present?
        color_mat_ids = MaterialProduct.joins(:material_product_color_systems).where(material_product_color_systems: { color_systems_id: @color_system.id }).pluck(:material_id)
        color_sam_ids = SampleColorSystem.where(color_systems_id: @color_system.id).pluck(:sample_id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', color_mat_ids, color_sam_ids)
      end

      # 价格
      if @price_start.present? && @price_end.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', @price_start, @price_end).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', @price_start, @price_end).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(low_price, SIGNED) <= ? AND CONVERT(high_price, SIGNED) >= ?', @price_start, @price_end).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      elsif @price_start.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(low_price, SIGNED) <= ?', @price_start).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(low_price, SIGNED) <= ?', @price_start).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(low_price, SIGNED) <= ?', @price_start).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      elsif @price_end.present?
        price_mat2_ids = MaterialInfo.where('CONVERT(high_price, SIGNED) >= ?', @price_end).pluck(:material_id)
        price_mat3_ids = MaterialProduct.where('CONVERT(high_price, SIGNED) >= ?', @price_end).pluck(:material_id)
        price_sam_ids = Sample.where('CONVERT(high_price, SIGNED) >= ?', @price_end).pluck(:id)
        @list = @list.where('(sample_id IS NULL AND material_id IN (?)) OR (sample_id IN (?))', [*price_mat2_ids, *price_mat3_ids], price_sam_ids)
      end

      if @area_id.present?
        area_mat_ids = MaterialProduct.joins(:material_product_areas).where(material_product_areas: { area_id: @area_id }).pluck(:material_id)
        @list = @list.where('material_id IN (?)', area_mat_ids)
      end

      @total = @list.count
      @list = @list.page(@page).per(@page_size)

      render 'list'
    end
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
      @projects = get_color_system_projects(@material)
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
      projects = Material.joins(:material_product).order(no: :asc)

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
