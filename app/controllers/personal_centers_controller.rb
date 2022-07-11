# frozen_string_literal: true

class PersonalCentersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_no_read_message_count
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def projects
    @page_size_options = [8, 12, 20, 36, 68]
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

    title = params[:title].presence&.strip
    status = params[:status].presence&.strip
    lv10_positions = current_user.positions.where('post_level >= 10')

    @list = CaseDelegate.joins(:record)
    # 如果存在部门10级及以上的职位，则获取该部门下所有的案例信息，否则只获取被委派的案例
    if lv10_positions.present?
      @list = @list.where('delegate_user_id = ? OR department_id IN (?)', current_user.id, lv10_positions.pluck(:department_id))
    else
      @list = @list.where(delegate_user_id: current_user.id)
    end
    @list = @list.where("`case_delegate_records`.project_name LIKE ?", "%#{title}%") if title.present?
    if status.present?
      s = CaseDelegate.web_status_hash[status.to_sym]
      @list = @list.where(status: s[:names]) if status.present? if s.present?
    end

    @total = @list.count
    @list = @list.page(@page).per(@page_size)
  end

  def messages
    @page_size_options = [5, 10, 20, 30, 50]
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

    @list = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .order(created_at: :desc)
    @total = @list.count
    @list = @list.page(@page).per(@page_size)
  end

  def set_message_read
    ids = params[:id]&.split(',')&.map { |id| id.to_i }
    raise Exception.new('ID不能为空') unless ids.present?

    messages = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .where(read_at: nil)
      .where(id: ids)
      .all
    messages.each do |message|
      message.read_at = Time.now
      message.save
    end

    if request.headers['HTTP_REFERER'].present?
      redirect_to request.headers['HTTP_REFERER']
    else
      redirect_to messages_personal_center_path
    end
  end

  def rm_message
    ids = params[:id]&.split(',')&.map { |id| id.to_i }
    raise Exception.new('ID不能为空') unless ids.present?

    messages = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .where(id: ids)
      .all
    messages.each do |message|
      message.deleted_at = Time.now
      message.save
    end

    redirect_to messages_personal_center_path
  end

  def demands
    @page_size_options = [10, 20, 40, 80, 160]
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

    @list = Demand
      .includes(:replies, :material)
      .where(clerk_code: current_user.clerk_code)
      .order(created_at: :desc)

    @total = @list.count
    @list = @list.page(@page).per(@page_size)
  end

  def suppliers
    @page_size_options = [10, 20, 40, 80, 160]
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

    @list = ManufacturerRecommend.where(user_id: current_user.id).order(created_at: :desc)

    @total = @list.count
    @list = @list.page(@page).per(@page_size)
  end

  def show_supplier
    manufacturer_recommend = ManufacturerRecommend.find(params[:id])
    render content_type: 'text/vnd.turbo-stream.html', turbo_stream: turbo_stream.replace('supplier_detail_modal_body', partial: 'personal_centers/supplier_detail_modal_body', locals: { manufacturer_recommend: manufacturer_recommend })
  end

  def create_supplier
    raise Exception.new('供应商名称不能为空') if params[:name].presence&.strip.blank?
    raise Exception.new('联系人不能为空') if params[:contactName].presence&.strip.blank?
    raise Exception.new('供应商类型不能为空') if params[:materialID].presence&.strip.blank?
    raise Exception.new('联系电话不能为空') if params[:contactTel].presence&.strip.blank?
    raise Exception.new('供应商优秀案例不能为空') if params[:cases].presence&.strip.blank?

    cases = JSON.parse(params[:cases])
    raise Exception.new('供应商优秀案例不能为空') unless cases.is_a?(Array) && cases.length > 0

    is_th_co = params[:isThCo] == 'true'
    inCount = 0

    cases.each do |c|
      raise Exception.new('每个案例的项目名称不能为空') if c['typeId'] != 'thtri' && c['name']&.strip.blank?
      raise Exception.new('每个案例的项目图片至少上传一张图片') unless c['livePhotos'].is_a?(Array) && c['livePhotos'].length > 0
      inCount+=1 if c['typeId'] == 'pm'
    end

    raise Exception.new('与天华合作过的供应商需要选择一个内部案例') if is_th_co && inCount <= 0

    res = ThtriApi.create_manufacturer_recommend({
      name: params[:name],
      contactName: params[:contactName],
      materialID: params[:materialID].to_i,
      contactTel: params[:contactTel],
      isThCo: is_th_co,
      reason: params[:reason],
      cases: cases
    }, { 'Cookie': request.headers['HTTP_COOKIE'] })

    redirect_to suppliers_personal_center_path
  end

  private
    def get_no_read_message_count
      @no_read_message_count = Notification
        .where(notifiable_id: current_user.id)
        .where('read_at IS NULL')
        .count
    end
end
