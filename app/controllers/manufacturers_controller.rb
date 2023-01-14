# frozen_string_literal: true

class ManufacturersController < ApplicationController
  before_action only: [:index], if: -> { request.variant.include?(:phone) } do
    redirect_to '/m/manufacturers'
  end
  before_action only: [:show], if: -> { request.variant.include?(:phone) } do
    redirect_to "/m/manufacturers/#{params[:id]}"
  end
  before_action :authenticate_user!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def index
    if turbo_frame_request?
      @page_size_options = [12, 20, 32, 56, 104]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

      mat_ids = (params[:ms].presence || []).reject(&:blank?)

      @area_ids = (params[:l].presence || []).reject(&:blank?).map(&:to_i)

      @sample_is_allow = params[:sample_is_allow] == 'on'
      @has_related_cases = params[:has_related_cases] == 'on'
      @has_cooperate_th = params[:has_cooperate_th] == 'on'

      @manufacturers = Manufacturer.sort_by_logo.order(is_allow: :desc).order(id: :asc)

      if @q.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{@q}%").pluck(:material_id)
        manufacturer_ids = MaterialManufacturer.where(material_id: q_mat_ids).pluck(:manufacturer_id)
        @manufacturers = @manufacturers.where('name LIKE :q_like OR location LIKE :q_like OR address LIKE :q_like OR website LIKE :q_like OR id IN (:manufacturer_ids)', q_like: "%#{@q}%", manufacturer_ids: manufacturer_ids)
      end

      if mat_ids.present?
        manufacturer_ids = MaterialManufacturer.where(material_id: mat_ids).pluck(:manufacturer_id)
        @manufacturers = @manufacturers.where('id IN (?)', manufacturer_ids)
      end

      if @area_ids.present?
        manufacturer_ids = ManufacturerArea.where(area_id: @area_ids).pluck(:manufacturer_id)
        @manufacturers = @manufacturers.where('id IN (?)', manufacturer_ids)
      end

      if @sample_is_allow.present?
        @manufacturers = @manufacturers.where(is_allow: true)
      end

      if @has_related_cases.present?
        @manufacturers = @manufacturers.where('id IN (?)', CaseManufacturer.select(:manufacturer_id).where.not(manufacturer_id: nil))
      end

      if @has_cooperate_th.present?
        @manufacturers = @manufacturers.where(is_tho_co: true)
      end

      @total = @manufacturers.count
      @manufacturers = @manufacturers.page(@page).per(@page_size)

      render 'list'
    end
  end

  def show
    @manufacturer = Manufacturer.find(params[:id])
    @samples = @manufacturer.samples
    @cases = @manufacturer.cases
    @materials = @manufacturer.materials.where(level: 3)
    @news = @manufacturer.news
    material3_ids = @manufacturer.materials.where(level: 3).pluck(:id)
    material2_ids = @manufacturer.materials.where(level: 2).pluck(:id)
    if material2_ids.present?
      material_ids = Material.where(level: 3).where(parent_id: material2_ids).pluck(:id)
      material2_ids.push(*material_ids) if material_ids.present?
    end
    material1_ids = @manufacturer.materials.where(level: 1).pluck(:id)
    if material1_ids.present?
      material_ids = Material.where(level: [2, 3]).where("parent_id IN (:ids) OR grandpa_id IN (:ids)", ids: material1_ids)
      material1_ids.push(*material1_ids) if material_ids.present?
    end
    manufacturer_fields = ['id', 'logo', 'name', 'location', 'address', 'is_allow', 'company_tel']
    @other_manufacturers = Manufacturer
      .select(Arel.sql("#{manufacturer_fields.map { |field| '`manufacturers`.' + field }.join(',')}, \
        MAX(( \
          CASE \
          WHEN `materials`.id IN (#{material3_ids.join(',').presence || 'null'}) THEN 3 \
          WHEN `materials`.id IN (#{material2_ids.join(',').presence || 'null'}) THEN 2 \
          WHEN `materials`.id IN (#{material1_ids.join(',').presence || 'null'}) THEN 1 \
          ELSE 0 \
          END \
        )) AS sort_num \
      "))
      .joins(:materials)
      .where.not(id: @manufacturer.id)
      .group(manufacturer_fields.map { |field| '`manufacturers`.' + field }.join(','))
      .order(Arel.sql("sort_num DESC, id ASC"))
      .limit(4)
  end

  def show_rating
    manufacturer_vote = ManufacturerVote.where(manufacturer_id: params[:id]).where(user_id: current_user.id).take
    @score = manufacturer_vote&.vote || 0
  end

  def update_rating
    ThtriApi.vote_for_manufacturer({
      manufacturer_id: params[:id],
      vote: params[:score].to_i,
    }, { 'Cookie': request.headers['HTTP_COOKIE'] })
    render json: { message: '更新成功' }
  end

  def show_feedback
    render content_type: 'text/vnd.turbo-stream.html', turbo_stream: turbo_stream.replace(
      :manufacturer_feedback_modal,
      partial: 'manufacturers/show_feedback',
      locals: {
        question_types: QuestionType.order(order_id: :desc).all.map do |question_type|
          { id: question_type.id, title: question_type.name }
        end,
        manufacturer_id: params[:id],
      }
    )
  end

  def create_feedback
    ThtriApi.create_manufacturer_feedback({
      manufacturer_id: params[:id],
      question_type_ids: params[:question_type_ids],
      description: params[:description],
      screenshot_path: params[:screenshot_path],
      references: params[:references],
    }, { 'Cookie': request.headers['HTTP_COOKIE'] })

    render json: { message: '提交成功' }
  end
end
