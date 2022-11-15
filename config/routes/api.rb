# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resource :aggregation, only: [] do
      member do
        get :home
        get :web_info
        get :materials
        get :color_systems
        get :material_locations
      end
    end

    resource :user, only: [] do
      member do
        get :me
      end
    end

    resources :materials, only: [:index, :show] do
      member do
        get :children
        get :color_systems
        get :paths
        get :samples
      end
    end

    resources :samples, only: [:show] do
      member do
        get :projects
        get :related_samples
      end
    end
  end
end
