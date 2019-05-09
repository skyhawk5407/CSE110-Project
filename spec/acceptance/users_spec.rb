# spec/acceptance/users_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'User' do
  explanation "Handles account and profile details"

  header "Content-Type", "application/json"

  post 'api/v1/users' do
    parameter :username, "The user's unique username.", type: :string
    parameter :password, "The user's password.", type: :string
    parameter :first_name, "The user's first name.", type: :string
    parameter :last_name, "The user's last name.", type: :string
    parameter :email, "The user's email.", type: :string

    context '200' do
      example 'Register a user' do
        request = {
          username: 'johnsmith2',
          password: 'password123',
          first_name: 'John',
          last_name: 'Smith',
          email: 'jsmith@example.com'
        }
        do_request(request)
        expect(status).to eq(200)
      end
    end
  end
end