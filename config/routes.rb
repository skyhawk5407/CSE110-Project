# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      post '/users' => 'user#create'
      delete '/users' => 'user#delete'
      get '/users/find_by_reset_token' => 'user#find_by_reset_token'
      post '/users/reset_password' => 'user#reset_password'
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index', format: false, via: :get, constraints: ->(req) { !req.env['PATH_INFO'].start_with?('/api') }
end