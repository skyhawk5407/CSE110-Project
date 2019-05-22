# frozen_string_literal: true

# localhost:3000/api/v1/apartments
class Api::V1::ApartmentController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment, except: [:create]
  def create
    # User only allowed to create apartment if they're not already in one
    user = User.find_by_email(request.headers['EMAIL'].to_s)
    return render plain: 'User already in an apartment', status: :bad_request unless user.apartment_id.nil?

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
    render :json => @apartment.as_json
  end

  def update_description
    filtered_params = {:name => params[:name],
                       :address => params[:address]}.reject{|_,v| v.nil?}
    if @apartment.update(filtered_params)
      render plain: 'Apartment description successfully updated', status: :ok
    else
      render :json => {:errors => @apartment.errors.full_messages}, status: :bad_request
    end
  end
end
