# frozen_string_literal: true

class ProjectRecordsController < ApplicationController
  before_action only: [:show], if: -> { request.variant.include?(:phone) } do
    redirect_to "/m/project_records/#{params[:id]}"
  end
  before_action :authenticate_any!

  def show
    @project = CaseDelegateRecord.find(params[:id])
  end
end
