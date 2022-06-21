# frozen_string_literal: true

class ManufacturerRecordsController < ApplicationController
  def show
    @manufacturer = ManufacturerRecord.find_by!(external_user_id: params[:id])
  end
end
