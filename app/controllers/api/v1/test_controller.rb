# frozen_string_literal: true

# localhost:3000/api/v1/test
class Api::V1::TestController < ActionController::API
  def get
    render json: {message: 'Test'}
  end
end
