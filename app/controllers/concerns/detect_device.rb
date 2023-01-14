# frozen_string_literal: true

module DetectDevice
  extend ActiveSupport::Concern

  included do
    before_action :set_variant_and_browser
  end

  def set_variant_and_browser
    @browser = Browser.new(request.user_agent)
    if @browser.mobile? || @browser.ipad?
      request.variant = :phone
    end
  end
end
