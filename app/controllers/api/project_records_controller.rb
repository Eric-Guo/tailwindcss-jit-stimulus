# frozen_string_literal: true

module Api
  class ProjectRecordsController < ApplicationController
    def show
      @project = CaseDelegateRecord.find(params[:id])
    end
  end
end
