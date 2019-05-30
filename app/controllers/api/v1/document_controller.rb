# frozen_string_literal: true

# localhost:3000/api/v1/apartments/documents
class Api::V1::DocumentController < ApplicationController
  before_action :authenticated?
  before_action :get_apartment
  before_action :get_document, only: [:update, :delete, :download]

  def upload
    # Decode the file
    begin
      base64_file = params[:file_data]
      decoded_file = Base64.decode64(base64_file)
      file_io = StringIO.new(decoded_file)
    rescue
      return render :json => {:errors => ['Could not decode document']}, status: :bad_request
    end

    # Create the document
    document = Document.new(
        :apartment_id => @apartment.id,
        :expense_id => params[:expense_id],
        :user_id => @user.id,
        :title => params[:title],
        :apartmentwide => params[:apartmentwide],
        :file_data => {:io => file_io, :filename => sanitize_filename(params[:filename])}
    )

    # Save the document
    if document.save
      render :json => document.to_json(request.base_url), status: :ok
    else
      render :json => {:errors => document.errors.full_messages}, status: :bad_request
    end
  end

  def get_all
    docs = Document.where(:apartment_id => @apartment.id)

    # Add the url and file data to each
    render :json => docs.map {|x| x.to_json(request.base_url)}
  end

  def download
    render :json => {:file_data => @document.encoded_file_data}
  end

  def update
    filtered_params = {:title => params[:title]}.reject{|_,v| v.nil?}
    return render :json => {:errors => ['Missing params']}, status: :bad_request if filtered_params.blank?
    if @document.update(filtered_params)
      render plain: 'Document successfully updated', status: :ok
    else
      render :json => {:errors => @document.errors.full_messages}, status: :bad_request
    end
  end

  def delete
    if @document.destroy
      render plain: 'Document successfully deleted', status: :ok
    else
      render :json => {:errors => @document.errors.full_messages}, status: :internal_server_error
    end
  end

  private
  def get_document
    begin
      @document = Document.find(params[:document_id])
    rescue
      return render :json => {:errors => ['Invalid document ID']}, status: :bad_request
    end
    render :json => {:errors => ['Unauthorized document ID(s)']}, status: :unauthorized unless @apartment.id == @document.apartment_id
  end
end
