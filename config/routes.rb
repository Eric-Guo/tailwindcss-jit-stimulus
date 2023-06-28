# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations invitations confirmations passwords unlocks], controllers: {
    sessions: 'sessions'
  }

  devise_for :visitors, skip: :all

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

  resources :project_records, only: %i[show]
  resources :projects, only: %i[index show]
  resources :manufacturers, only: %i[index show] do
    member do
      get :rating, action: :show_rating
      post :rating, action: :update_rating
      get :feedback, action: :show_feedback
      post :feedback, action: :create_feedback
    end
  end
  resources :manufacturer_records, only: %i[show]
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

  namespace :personal_center do
    resources :projects, only: [:index]
    resources :messages, only: [:index, :update, :remove] do
      collection do
        put :update, to: 'messages#update'
        delete :remove, to: 'messages#remove'
      end
    end
    resources :demands, only: [:index, :show]
    resources :feedbacks, only: [:index, :show]
    resources :suppliers, only: [:index, :show, :new, :create] do
      collection do
        get :pm_projects
        get :matlib_projects
        post :create_project
        post :create_project_image
      end
    end
    resources :visitors, only: [:index, :new, :create, :edit, :update] do
      member do
        put :disable
      end
    end
    resources :helpers, only: [:index]
  end

  resource :thtri_api, only: [] do
    member do
      post :upload_img
      get :pm_projects
      get :matlib_projects
    end
  end

  resources :lmkzscs, only: [] do
    member do
      get :download
    end
  end

  resources :relevant_documents, only: [] do
    member do
      get :download
    end
  end

  resource :wechat, only: [:show, :create]
  root 'home#index'

  draw(:api)
end
