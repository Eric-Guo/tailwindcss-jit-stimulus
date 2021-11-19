# frozen_string_literal: true

Rails.application.routes.draw do
  resources :samples, only: [:show] do
    member do
      get :other_samples
      get :projects
    end
  end
  resources :materials, only: %i[index show] do
    member do
      get :color_system_list
      get :download_texture
      get :samples
    end
  end

  resources :projects, only: %i[index]
  resources :manufacturers, only: %i[index]
  resources :news, only: %i[index]

  resource :search, only: [] do
    get :material
    get :project
    get :manufacturer
    get :news
  end

  root 'home#index'
end
