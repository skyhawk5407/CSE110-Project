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

  post 'api/v1/users/update_profile' do
    before (:each) do
      # Seed with an existing user and apartment
      @existing_user = User.create(
          :email => 'jsmith@example.com',
          :password => 'password123',
          :display_name => 'John Smith'
      )
    end

    parameter :display_name, "The user's display name (i.e. first and last).", type: :string
    parameter :password, "The user's password.", type: :string

    header 'EMAIL', 'jsmith@example.com'
    header 'PASSWORD', 'password123'

    context '200' do
      example '1. Update profile - Success' do
        explanation 'Update the current user\'s display name and password.'
        display_name = 'John'
        password = 'password1234'
        do_request
        expect(status).to eq(200)
      end
      example '2. Update profile - Supply partial info' do
        explanation 'Update the current user\'s display name or password only.'
        display_name = 'John'
        do_request
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:display_name) {''}
      let(:password) {'password1234'}
      example_request '3. Update profile - Failure' do
        explanation 'Supply invalid display name and/or password.'
        expect(status).to eq(400)
      end
    end
  end

  post 'api/v1/users/join_apartment' do
    before (:each) do
      # Seed with an existing user and apartment
      @existing_user = User.create(
          :email => 'jsmith@example.com',
          :password => 'password123',
          :display_name => 'John Smith'
      )
      @existing_apartment = Apartment.create(
          :name => 'Example apartment',
          :address => '9500 Gilman Dr, La Jolla, CA 92093'
      )
      @existing_apartment2 = Apartment.create(
          :name => 'Example apartment2',
          :address => '9501 Gilman Dr, La Jolla, CA 92093'
      )
      @access_code1 = @existing_apartment.access_code
      @access_code2 = @existing_apartment2.access_code
    end

    parameter :access_code, "The apartment's access code.", type: :string

    header 'EMAIL', 'jsmith@example.com'
    header 'PASSWORD', 'password123'

    context '200' do
      let(:access_code) {@access_code1}
      example_request '1. Join Apartment - Success' do
        explanation 'Join an apartment. The user cannot be part of an existing apartment.'
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:access_code) {@access_code2}
      example '2. Join Apartment - Failure (User already in apartment)' do
        explanation 'Attempt to join an apartment while already in one.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(400)
      end
    end
  end

  post 'api/v1/users/leave_apartment' do
    before (:each) do
      # Seed with an existing user and apartment
      @existing_user = User.create(
          :email => 'jsmith@example.com',
          :password => 'password123',
          :display_name => 'John Smith'
      )
      @existing_apartment = Apartment.create(
          :name => 'Example apartment',
          :address => '9500 Gilman Dr, La Jolla, CA 92093'
      )
    end

    header 'EMAIL', 'jsmith@example.com'
    header 'PASSWORD', 'password123'

    context '200' do
      example '1. Leave Apartment - Success' do
        explanation 'Leave an apartment. The user must be part of an existing apartment.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end
    context '400' do
      example_request '2. Leave Apartment - Failure (User not already in apartment)' do
        explanation 'Attempt to leave an apartment while not in one.'
        expect(status).to eq(400)
      end
    end
  end

  post 'api/v1/users/reset_password' do
    before (:each) do
      # Seed with an existing user
      @existing_user = User.create(
          :email => 'jsmith@example.com',
          :password => 'password123',
          :display_name => 'John Smith'
      )
    end

    parameter :reset_token, 'The user\'s reset token.', type: :string
    parameter :new_password, 'The user\'s desired new password.', type: :string

    context '200' do
      let(:reset_token) {@existing_user.reset_token}
      let(:new_password) {'password1234'}
      example_request '1. Reset Password - Success' do
        explanation 'Reset the user\'s password with new_password by supplying the correct reset token.'
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:reset_token) {@existing_user.reset_token}
      let(:new_password) {'p'}
      example '2. Reset Password - Failure (Invalid password)' do
        explanation 'Attempt to reset the password with an invalid password.'
        reset_token = @existing_user.reset_token
        new_password = 'a'
        do_request
        expect(status).to eq(400)
      end
    end
    context '401' do
      let(:reset_token) {'incorrect-token'}
      let(:new_password) {'password1234'}
      example '3. Reset Password - Failure (Incorrect token)' do
        explanation 'Attempt to reset the password using the incorrect token.'
        do_request
        expect(status).to eq(401)
      end
    end
  end
end