# spec/acceptance/users_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'User' do
  explanation "Handles user account and profile."

  header "Content-Type", "application/json"

  post 'api/v1/users' do
    parameter :username, "The user's unique username.", type: :string
    parameter :password, "The user's password.", type: :string
    parameter :first_name, "The user's first name.", type: :string
    parameter :last_name, "The user's last name.", type: :string
    parameter :email, "The user's email.", type: :string

    context '200' do
      let(:username) {'johnsmith2'}
      let(:password) {'password123'}
      let(:first_name) {'John'}
      let(:last_name) {'Smith'}
      let(:email) {'jsmith@example.com'}

      example_request '1. User registration - register a user' do
        explanation 'Register a new user, providing all the necessary fields. The new user will be inserted into the database.'
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'insufficient fields' do
        let(:email) { "jsmith@example.com" }
        example '2. User registration - insufficient fields' do
          explanation 'Example of supplying insufficient information. The new user will not be inserted into the database.'
          do_request
          expect(status).to eq(400)
        end
      end

      context 'duplicates' do
        let(:username) {'johnsmith2'}
        let(:password) {'password123'}
        let(:first_name) {'John'}
        let(:last_name) {'Smith'}
        let(:email) {'jsmith@example.com'}
        example '3. User registration - username taken' do
          explanation 'Attempting to register the same user twice. The duplicate user will not be inserted into the database.'

          # Set up existing user
          user = User.create(
              :username => 'johnsmith2',
              :password => 'password123',
              :reset_token => SecureRandom.uuid,
              :first_name => 'John',
              :last_name => 'Smith',
              :email => 'jsmith@example.com')
          expect(user).to be_valid

          # Now the request should fail
          do_request
          expect(status).to eq(400)
        end
      end
    end
  end
end