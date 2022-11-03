# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource :aggregation, only: [] do
      member do
        get :home
      end
    end
    
    resources :materials
  end
end
