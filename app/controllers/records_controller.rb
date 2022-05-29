# frozen_string_literal: true

class RecordsController < ApplicationController
  before_action :authenticate_user!
  def show
    @project = CaseDelegateRecord.find(params[:id])
  end
end
