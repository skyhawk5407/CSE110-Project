# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      # Users
      post 'users/' => 'user#register'
      delete 'users/' => 'user#delete'
      get 'users/login' => 'user#login'
      post 'users/update_profile' => 'user#update_profile'
      post 'users/join_apartment' => 'user#join_apartment'
      post 'users/reset_password' => 'user#reset_password'
      get 'users/find_by_reset_token' => 'user#find_by_reset_token'

      # Apartments
      post 'apartments/' => 'apartment#create'
      delete 'apartments/' => 'apartment#delete'
      get 'apartments/' => 'apartment#get'
      post 'apartments/update_description' => 'apartment#update_description'

=begin
      # Documents
      post 'apartments/documents/upload' => 'document#upload'
      get 'apartments/documents' => 'document#get'
      post 'apartments/documents/update' => 'document#update'
      delete 'apartments/documents' => 'document#delete'

      # Expenses
      post 'apartments/expenses' => 'expense#create'
      get 'apartments/expenses' => 'expense#get'
      post 'apartments/expenses/update' => 'expense#update'
      delete 'apartments/expenses' => 'expense#delete'

      # Notifications
      post 'apartments/notifications' => 'notifications#create'
      get 'apartments/notifications' => 'notifications#get'
      post 'apartments/notifications/mark_read' => 'notifications#mark_read'

      # Items

      # Rules
      post
=end
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index',
        format: false, via: :get,
        constraints: ->(req) { !req.env['PATH_INFO'].start_with?('/api') }
end