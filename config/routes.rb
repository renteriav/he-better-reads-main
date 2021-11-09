# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             defaults: { format: :json },
             path: '',
             path_names: {
               sign_in: 'api/login',
               sign_out: 'api/logout',
               registration: 'api/signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  namespace :api, defaults: { format: :json } do
    resources :authors, only: %i[create index show update]
    resources :books, only: %i[create index show update]
    resources :users, only: %i[create index show update]

    resources :authors do
      resources :reviews, only: %i[create index show update]
    end

    resources :books do
      resources :reviews, only: %i[create index show update]
    end
  end
end
