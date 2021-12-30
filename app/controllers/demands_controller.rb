# frozen_string_literal: true

class DemandsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    data = create_params
    res = Demand.submit({
      UserName: current_user.chinese_name,
      ClerkCode: current_user.clerk_code,
      demandType: data[:cate],
      material: data[:material],
      description: data[:description],
      references: data[:files]
    })
    render json: res
  end

  def upload_file
    res = Demand.upload_file(params[:file])
    render json: res
  end

  private
    def create_params
      params.require(:demand)
    end
end
