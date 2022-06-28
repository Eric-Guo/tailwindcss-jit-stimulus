# frozen_string_literal: true

class PersonalCentersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_no_read_message_count

  def projects
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

  end

  def messages
    @list = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .order(created_at: :desc)
      .all
  end

  def set_message_read
    if params[:all].present?
      messages = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .where(read_at: nil)
      .all
      read_at = Time.now
      messages.each do |message|
        message.read_at = read_at
        message.save
      end
    else
      message = Notification
        .where(notifiable_type: 'cybros.user')
        .where(notifiable_id: current_user.id)
        .find(params[:id])

      if message.read_at.blank?
        message.read_at = Time.now
        message.save
      end
    end

    redirect_to messages_personal_center_path
  end

  def rm_message
    message = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .find(params[:id])
    message.deleted_at = Time.now
    message.save

    redirect_to messages_personal_center_path
  end

  def demands
    @list = Demand
      .includes(:replies, :material)
      .where(clerk_code: current_user.clerk_code)
      .order(created_at: :desc)
      .all
  end

  def suppliers
    @list = ManufacturerRecommend.where(user_id: current_user.id).all
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
    raise Exception.new('推荐理由不能为空') if params[:reason].presence&.strip.blank?
    raise Exception.new('供应商优秀案例不能为空') if params[:cases].presence&.strip.blank?
    res = ThtriApi.create_manufacturer_recommend({
      name: params[:name],
      contactName: params[:contactName],
      materialID: params[:materialID].to_i,
      contactTel: params[:contactTel],
      isThCo: params[:isThCo] == 'true',
      reason: params[:reason],
      cases: JSON.parse(params[:cases])
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
