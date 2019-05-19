# spec/acceptance/user_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'User' do
  explanation "Handles user account and profile."

  header "Content-Type", "application/json"

  post 'api/v1/users' do
    parameter :email, "The user's email.", type: :string
    parameter :password, "The user's password.", type: :string
    parameter :display_name, "The user's display name (i.e. first and last).", type: :string

    context '200' do
      let(:email) {'jsmith@example.com'}
      let(:password) {'password123'}
      let(:display_name) {'John Smith'}

      example_request '1. User registration - register a user' do
        explanation 'Register a new user, providing all the necessary fields. The new user will be inserted into the database.'
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'insufficient fields' do
        let(:email) { "jsmith@example.com" }

        example_request '2. User registration - insufficient fields' do
          explanation 'Example of supplying insufficient information. The new user will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end

      context 'duplicates' do
        let(:email) {'jsmith@example.com'}
        let(:password) {'password123'}
        let(:display_name) {'John Smith'}

        example '3. User registration - username taken' do
          explanation 'Attempting to register the same user twice. The duplicate user will not be inserted into the database.'

          # Set up existing user
          user = User.create(
              :email => 'jsmith@example.com',
              :password => 'password123',
              :display_name => 'John Smith')
          expect(user).to be_valid

          # Now the request should fail
          do_request
          expect(status).to eq(400)
        end
      end
    end
  end

  delete 'api/v1/users' do
    context '200' do
      example '1. User deletion' do
        explanation 'Delete the currently logged in user.'

        header 'EMAIL', 'jsmith@example.com'
        header 'PASSWORD', 'password123'

        # Set up existing user
        user = User.create(
            :email => 'jsmith@example.com',
            :password => 'password123',
            :display_name => 'John Smith')
        expect(user).to be_valid

        # Should delete the user
        do_request
        expect(status).to eq(200)
      end
    end
  end

  get 'api/v1/users/login' do
    context '200' do
      example '1. User login - Success' do
        explanation 'Verify the user\'s email and password.'

        header 'EMAIL', 'jsmith@example.com'
        header 'PASSWORD', 'password123'

        # Set up existing user
        user = User.create(
            :email => 'jsmith@example.com',
            :password => 'password123',
            :display_name => 'John Smith')
        expect(user).to be_valid

        # Should confirm login
        do_request
        expect(status).to eq(200)
      end
    end

    context '401' do
      example '2. User login - Failure' do
        explanation 'Reject the user\'s incorrect email and password.'

        header 'EMAIL', 'jsmith@example.com'
        header 'PASSWORD', 'wrong-password'

        # Set up existing user
        user = User.create(
            :email => 'jsmith@example.com',
            :password => 'password123',
            :display_name => 'John Smith')
        expect(user).to be_valid

        # Should confirm login
        do_request
        expect(status).to eq(401)
      end
    end
  end
end