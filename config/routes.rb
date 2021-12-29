# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations invitations confirmations passwords unlocks]
  get 'auth/openid_connect/callback', to: 'openid_connect#callback'

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

  resources :projects, only: %i[index show]
  resources :manufacturers, only: %i[index show]
  resources :news, only: %i[index]

  resource :search, only: [:show] do
    get :material
    get :project
    get :manufacturer
    get :news
  end

  resources :material_types, only: %i[show]

  resource :wechat, only: [:show, :create]
  root 'home#index'
end
