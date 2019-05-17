# frozen_string_literal: true

# localhost:3000/api/v1/user
class Api::V1::UserController < ApplicationController
  before_action :authenticated?, only: [:delete, :update_profile]

  # Register new user
  def register
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

    render plain: 'User creation successful', status: :ok
  end

  def delete
    user = User.find_by_username(params[:auth][:username])
    user.destroy
    head :ok
  end

  def find_by_reset_token
    user = User.find_by_reset_token(params[:reset_token])
    render plain: 'invalid token', status: :unauthorized if user.nil?

    render json: {username: user.username}
  end

  # Reset password of user using reset token
  def reset_password
    user = User.find_by_reset_token(params[:reset_token])
    render plain: 'invalid token', status: :unauthorized if user.nil?
    user.update_password(params[:new_password])
    render plain: 'Password successfully updated', status: :ok
  end

  # Update first name, last name, password
  def update_profile
    user = User.find_by_username(params[:auth][:username])
    render json: 'invalid user id', status: :unauthorized if user.nil?

    if user.update({:first_name => params[:first_name],
                    :last_name => params[:last_name],
                    :password => params[:password]}.reject{|_,v| v.blank?})
      render plain: 'Profile successfully updated', status: :ok
    else
      render :json => {:errors => user.errors.full_messages}, status: :bad_request
    end
  end
end
