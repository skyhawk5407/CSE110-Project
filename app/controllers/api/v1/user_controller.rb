# frozen_string_literal: true

# localhost:3000/api/v1/user
class Api::V1::UserController < ApplicationController
  before_action :authenticated?, only: [:delete]

  # Add new user
  def create
    user = User.find_by username: params[:account_name]
    return render plain: 'User with this username already exists', status: :bad_request unless user.nil?

    user = User.create(
      :username => params['username'],
      :password => params['password'],
      :reset_token => SecureRandom.uuid,
      :first_name => params['first_name'],
      :last_name => params['last_name'],
      :email => params['email']
    )
    return render :json => {:errors => user.errors.full_messages}, status: :bad_request unless user.valid?

    render plain: 'User creation successful'
  end

  # Delete (requires auth)
  def delete
    User.find_by_username(params[:username]).destroy
    head :ok
  end

  def find_by_reset_token
    user = User.find_by_reset_token(params[:reset_token])
    render json: 'invalid token', status: :unauthorized if user.nil?

    render json: {username: user.username}
  end

  # Reset password of user
  def reset_password
    user = User.find_by_reset_token(params[:reset_token])
    render json: 'invalid token', status: :unauthorized if user.nil?

    user.update_password(params[:password])

    head :ok
  end
end
