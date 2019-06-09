# frozen_string_literal: true

# localhost:3000/api/v1/apartments/items
class Api::V1::ItemController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment
  before_action :get_item, only: [:update, :delete]

  def create
    # Decode the file
    begin
      base64_file = params[:image_data]
      decoded_file = Base64.decode64(base64_file)
      file_io = StringIO.new(decoded_file)
      image = {:io => file_io, :filename => sanitize_filename(params[:filename])}
    rescue
      image = nil
    end

    # Create the item
    item = Item.new(
        :apartment_id => @apartment.id,
        :user_id => params[:owner_id],
        :image => image,
        :name => params[:name],
        :bought => params[:bought],
        :description => params[:description]
    )

    # Save the item
    if item.save
      render :json => item.to_json(request.base_url), status: :ok
    else
      render :json => {:errors => item.errors.full_messages}, status: :bad_request
    end
  end

  def get_all
    items = Item.where(:apartment_id => @apartment.id)

    # Add the url and file data to each
    render :json => items.map {|x| x.to_json(request.base_url)}
  end

  def update
    # Decode the file
    begin
      base64_file = params[:image_data]
      decoded_file = Base64.decode64(base64_file)
      file_io = StringIO.new(decoded_file)
      image = {:io => file_io, :filename => sanitize_filename(params[:filename])}
    rescue
      image = nil
    end
    filtered_params = {:name => params[:name],
                       :bought => params[:bought],
                       :description => params[:description],
                       :image => image}.reject {|_, v| v.nil?}
    if params.has_key? :owner_id
      filtered_params = filtered_params.merge({:user_id => params[:owner_id]})
    end

    return render json: {:errors => ['Missing params']}, status: :bad_request if filtered_params.blank?
    if @item.update(filtered_params)
      render plain: 'Item successfully updated', status: :ok
    else
      render :json => {:errors => @item.errors.full_messages}, status: :bad_request
    end
  end

  def delete
    if @item.destroy
      render plain: 'Item successfully deleted', status: :ok
    else
      render :json => {:errors => @item.errors.full_messages}, status: :internal_server_error
    end
  end

  private

  def get_item
    begin
      @item = Item.find(params[:item_id])
    rescue
      return render json: {:errors => ['Invalid item ID']}, status: :bad_request
    end
    render json: {:errors => ['Unauthorized item ID']}, status: :unauthorized unless @apartment.id == @item.apartment_id
  end
end
