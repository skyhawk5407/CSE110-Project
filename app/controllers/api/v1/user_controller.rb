# frozen_string_literal: true

# localhost:3000/api/v1/users
class Api::V1::UserController < ApplicationController
  before_action :authenticated?, only: [:delete, :update_profile, :login, :join_apartment, :leave_apartment]

  # Register new user
  def register
    user = User.find_by_email(params[:email])
    return render plain: 'User with this email already exists', status: :bad_request unless user.nil?

    user = User.create(
      :email => params['email'],
      :password => params['password'],
      :reset_token => SecureRandom.uuid,
      :display_name => params['display_name']
    )
    return render :json => {:errors => user.errors.full_messages}, status: :bad_request unless user.valid?

    render plain: 'User creation successful', status: :ok
  end

  def delete
    user = User.find_by_email(request.headers['EMAIL'].to_s)
    user.destroy
    render plain: 'User deletion successful', status: :ok
  end

  # Reset password of user using reset token
  def reset_password
    user = User.find_by_reset_token(params[:reset_token])
    return render plain: 'Invalid token', status: :unauthorized if user.nil?
    if user.update(:password => params[:new_password])
      render plain: 'Password successfully updated', status: :ok
    else
      render :json => {:errors => user.errors.full_messages}, status: :bad_request
    end

  end

  # Update display name, password
  def update_profile
    user = User.find_by_email(request.headers['EMAIL'].to_s)
    return render json: 'Invalid user email', status: :unauthorized if user.nil?

    filtered_params = {:display_name => params[:display_name],
                       :password => params[:password]}.reject{|_,v| v.nil?}
    if user.update(filtered_params)
      render plain: 'Profile successfully updated', status: :ok
    else
      render :json => {:errors => user.errors.full_messages}, status: :bad_request
    end
  end

  def login
    render :json => User.find_by_email(request.headers['EMAIL'].to_s)
                        .as_json
  end

  def join_apartment
    user = User.find_by_email(request.headers['EMAIL'].to_s)
    return render plain: 'User already in an apartment', status: :bad_request unless user.apartment_id.nil?
    apartment = Apartment.find_by_access_code(params[:access_code])
    user.update_column(:apartment_id, apartment.id)
    render plain: 'Successfully joined apartment', status: :ok
  end

  def leave_apartment
    user = User.find_by_email(request.headers['EMAIL'].to_s)
    return render plain: 'User not already in an apartment', status: :bad_request if user.apartment_id.nil?
    user.update_column(:apartment_id, nil)
    render plain: 'Successfully left apartment', status: :ok
  end
end
