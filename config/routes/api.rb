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
        get :project_locations
        get :project_types
        get :manufacturer_locations
        get :my_project_config
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

    resources :projects, only: [:index, :show] do
      member do
        get :related_projects
      end
    end

    resources :manufacturers, only: [:index, :show] do
      member do
        get :related_manufacturers
      end
    end

    resources :news, only: [:index]

    namespace :my do
      resources :projects, only: [:index]
      resources :messages, only: [:index, :destroy] do
        member do
          put :read
        end
      end
      resources :demands, only: [:index, :show]
    end
  end
end
