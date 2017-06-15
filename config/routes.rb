require 'api_constraints'

Rails.application.routes.draw do
  namespace :api,
            defaults: { format: :json },
            # constraints: { subdomain: 'api' },
            path: '/' do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: %i[create show update destroy] do
        resources :products, only: %i[create update destroy]
      end

      resources :sessions, only: %i[create destroy]
      resources :products, only: %i[index show]
      resources :orders, only: %i[index show create]
    end
  end

  devise_for :users
end
