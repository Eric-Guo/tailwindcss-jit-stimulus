# frozen_string_literal: true

Rails.application.routes.draw do
  resources :samples, only: [:show]
  resources :materials, only: [:show]

  resource :search, only: [:show]
  root 'home#index'
end
