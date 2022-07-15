# frozen_string_literal: true

class ProjectRecordsController < ApplicationController
  before_action :authenticate_user!

  def show
    @project = CaseDelegateRecord.find(params[:id])
  end
end
