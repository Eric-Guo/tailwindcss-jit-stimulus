# frozen_string_literal: true

module PersonalCenter
  class SuppliersController < ApplicationController
    before_action do
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def index
      @page_size_options = [10, 20, 40, 80, 160]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @list = ManufacturerRecommend.where(user_id: current_user.id).order(created_at: :desc)

      @total = @list.count
      @list = @list.page(@page).per(@page_size)
    end

    def show
      @manufacturer_recommend = ManufacturerRecommend.find(params[:id])
    end

    def new
    end

    def create
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

      redirect_to personal_center_suppliers_path
    end

    def pm_projects
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 10

      res = ThtriApi.pm_projects({
        page: @page,
        pageSize: @page_size,
        projectName: params[:keywords],
      }, { 'Cookie': request.headers['HTTP_COOKIE'] })

      @list = res['list'].map do |item|
        {
          code: item['projectCode'],
          title: item['projectName'],
          company: item['companyName'],
          department: item['departmentName'],
        }
      end
      @total = res['total']
    end

    def matlib_projects
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 10

      res = ThtriApi.matlib_projects({
        page: @page,
        pageSize: @page_size,
        projectName: params[:keywords],
      }, { 'Cookie': request.headers['HTTP_COOKIE'] })

      @list = res['list'].map do |item|
        {
          id: item['ID'],
          code: item['no'],
          title: item['projectName'],
          livePhotoList: item['livePhotoList'],
          cover: item['web_cover'],
        }
      end
      @total = res['total']
    end
  end
end
