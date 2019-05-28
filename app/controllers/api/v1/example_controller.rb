# frozen_string_literal: true

# localhost:3000/api/v1/example
class Api::V1::ExampleController < ApplicationController
  def post
    return render :json => {:errors => ['Invalid name']}, status: :bad_request if params[:name].nil? or params[:name].blank?
    render json: {:message => 'Hello %s!' % params[:name]}, status: :ok
  end
end
