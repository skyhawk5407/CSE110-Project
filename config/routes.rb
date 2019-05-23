# frozen_string_literal: true

Rails.application.routes.draw do
  # Api definition
  namespace :api do
    namespace :v1 do
      # Example
      post 'example/' => 'example#post'

      # Users
      post 'users/' => 'user#register'
      delete 'users/' => 'user#delete'
      get 'users/login' => 'user#login'
      post 'users/update_profile' => 'user#update_profile'
      post 'users/issue_reset_email' => 'user#issue_reset_email'
      post 'users/join_apartment' => 'user#join_apartment'
      post 'users/leave_apartment' => 'user#leave_apartment'
      post 'users/reset_password' => 'user#reset_password'

      # Apartments
      post 'apartments/' => 'apartment#create'
      delete 'apartments/' => 'apartment#delete'
      get 'apartments/' => 'apartment#get'
      post 'apartments/update_description' => 'apartment#update_description'
      post 'apartments/remove_user' => 'apartment#remove_user'

      # Documents
      post 'apartments/documents/upload' => 'document#upload'
      get 'apartments/documents/all' => 'document#get_all'
      post 'apartments/documents/update' => 'document#update'
      delete 'apartments/documents' => 'document#delete'

      # Expenses
      post 'apartments/expenses' => 'expense#create'
      get 'apartments/expenses/all' => 'expense#get_all'
      post 'apartments/expenses/mark_paid' => 'expense#mark_paid'
      delete 'apartments/expenses' => 'expense#delete'

      # Notifications
      # TODO
      # post 'apartments/notifications' => 'notifications#create'
      # get 'apartments/notifications' => 'notifications#get'
      # post 'apartments/notifications/mark_read' => 'notifications#mark_read'

      # Items
      # TODO
    end
  end

  root to: 'landing#index'
  match '*path', to: 'landing#index',
        format: false, via: :get,
        constraints: ->(req) { !req.env['PATH_INFO'].start_with?('/api') and !req.env['PATH_INFO'].start_with?('/rails') }
end