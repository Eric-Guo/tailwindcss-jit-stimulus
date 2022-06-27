# frozen_string_literal: true

class ThtriApisController < ApplicationController
  before_action :authenticate_user!

  def upload_img
    res = ThtriApi.upload_img(params[:file], { 'Cookie': request.headers['HTTP_COOKIE'] })
    render json: res
  end

  # 获取pm案例
  def pm_projects
    res = ThtriApi.pm_projects({
      page: params[:page],
      pageSize: params[:pageSize],
      projectName: params[:keywords],
    }, { 'Cookie': request.headers['HTTP_COOKIE'] })
    render json: {
      list: res['list'].map { |item|
        {
          code: item['projectCode'],
          title: item['projectName'],
          company: item['companyName'],
          department: item['departmentName'],
        }
      },
      total: res['total'],
    }
  end

  def matlib_projects
    res = ThtriApi.matlib_projects({
      page: params[:page],
      pageSize: params[:pageSize],
      projectName: params[:keywords],
    }, { 'Cookie': request.headers['HTTP_COOKIE'] })
    render json: {
      list: res['list'].map { |item|
        {
          id: item['ID'],
          code: item['no'],
          title: item['projectName'],
          livePhotoList: item['livePhotoList'],
          cover: item['web_cover'],
        }
      },
      total: res['total'],
    }
  end
end
