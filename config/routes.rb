# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      get '/test' => 'test#get'
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index', format: false, via: :get, constraints: ->(req) { !req.env['PATH_INFO'].start_with?('/api') }
end