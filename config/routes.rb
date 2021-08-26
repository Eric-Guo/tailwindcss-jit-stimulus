# frozen_string_literal: true

Rails.application.routes.draw do
  resources :samples, only: [:show]

  root 'home#index'
end
