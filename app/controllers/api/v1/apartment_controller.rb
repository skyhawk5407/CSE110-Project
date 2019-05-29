# frozen_string_literal: true

# localhost:3000/api/v1/apartments
class Api::V1::ApartmentController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment, except: [:create]
  def create
    # User only allowed to create apartment if they're not already in one
    user = User.find_by_email(request.headers['EMAIL'].to_s.downcase)
    return render :json => {:errors => ['User already in an apartment']}, status: :bad_request unless user.apartment_id.nil?

    # Create apartment
    apartment = Apartment.create(
        :name => params['name'],
        :address => params['address']
    )
    return render :json => {:errors => apartment.errors.full_messages}, status: :bad_request unless apartment.valid?

    # Set user to be part of new apartment
    user.update_column(:apartment_id, apartment.id)
    render plain: 'Apartment creation successful', status: :ok
  end

  def delete
    # Delete apartment
    if @apartment.destroy
      render plain: 'Apartment deletion successful', status: :ok
    else
      render :json => {:errors => @apartment.errors.full_messages}, status: :internal_server_error
    end
  end

  def get
    users = User.where(:apartment_id => @apartment.id)
    render :json => @apartment.as_json.merge(:users => users)
  end

  def update_description
    filtered_params = {:name => params[:name],
                       :address => params[:address]}.reject{|_,v| v.nil?}
    return render :json => {:errors => ['Missing params']}, status: :bad_request if filtered_params.blank?
    if @apartment.update(filtered_params)
      render plain: 'Apartment description successfully updated', status: :ok
    else
      render :json => {:errors => @apartment.errors.full_messages}, status: :bad_request
    end
  end

  def issue_invite_email
    ApartmentMailer.with(:email => params[:email],
                         :apartment => @apartment,
                         :user => @user).invite.deliver_now
    render plain: 'Email sent', status: :ok
  end

  def remove_user
    return render :json => {:errors => ['Cannot remove self']}, status: :bad_request if params[:user_id] == @user.id
    user_to_remove = User.find_by_id(params[:user_id])
    return render :json => {:errors => ['Not in same apartment']}, status: :bad_request if user_to_remove.nil? or user_to_remove.apartment_id != @user.apartment_id

    user_to_remove.leave_apartment
    render plain: 'User removed from apartment', status: :ok
  end
end
