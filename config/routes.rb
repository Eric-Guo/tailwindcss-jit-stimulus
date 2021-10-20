# frozen_string_literal: true

Rails.application.routes.draw do
  resources :samples, only: [:show] do
    member do
      get :prev_other_samples
      get :next_other_samples
      get :prev_projects
      get :next_projects
    end
  end
  resources :materials, only: [:show] do
    member do
      get :color_system_list
    end
  end

  resource :search, only: [] do
    get :material
    get :project
    get :manufacturer
    get :news
  end

  root 'home#index'
end
