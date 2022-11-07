# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource :aggregation, only: [] do
      member do
        get :home
        get :web_info
        get :materials
      end
    end
    
    resources :materials
  end
end
