# frozen_string_literal: true

class DemandsController < ApplicationController
  before_action :authenticate_user!

  def create
    res = ThtriApi.demand_submit({
      UserName: current_user.chinese_name,
      ClerkCode: current_user.clerk_code,
      demandType: params[:cate].to_i,
      material_id: params[:material].to_i,
      description: params[:description],
      references: params[:files]
    }, request.remote_ip)
    render json: res
  end

  def upload_file
    res = ThtriApi.demand_upload_file(params[:file])
    render json: res
  end
end
