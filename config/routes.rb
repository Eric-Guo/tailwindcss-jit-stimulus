# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations invitations confirmations passwords unlocks], controllers: {
    sessions: 'sessions'
  }

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

  resources :records, only: %i[show]
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

  resource :demand, only: %i[create] do
    post :upload_file
  end

  resource :personal_center, only: [] do
    member do
      get :projects
      get :messages
      get :demands
      get :suppliers
      put :set_message_read
      delete :rm_message
    end
  end

  resource :wechat, only: [:show, :create]
  root 'home#index'
end
