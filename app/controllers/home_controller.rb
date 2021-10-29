# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @latest_news = News.order(updated_at: :desc).limit(4)
  end
end
