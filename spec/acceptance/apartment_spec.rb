# spec/acceptance/apartment_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Apartment' do
  explanation "Handles creation and updates to apartment."

  header "Content-Type", "application/json"

  header 'EMAIL', :email_header
  header 'PASSWORD', :password_header
  let(:email_header) {'jsmith@example.com'}
  let(:password_header) {'password123'}

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
    @existing_user2 = User.create(
        :email => 'jdoe@example.com',
        :password => 'password12',
        :display_name => 'Jane Doe',
        :apartment_id => @existing_apartment.id
    )
  end

  post 'api/v1/apartments' do
    parameter :address, "The apartment's address.", type: :string
    parameter :name, "The apartment's name/title.", type: :string

    context '200' do
      let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}
      let(:name) {'John\'s Apartment'}

      example_request 'Apartment creation' do
        explanation 'Create a new apartment, providing all the necessary fields. The new apartment will be inserted into the database.\n Note: The user is not currently in an apartment.'
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'insufficient fields' do
        let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}

        example_request 'Apartment creation - Insufficient fields' do
          explanation 'Example of supplying insufficient information. The new apartment will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end

      context 'user is already in apartment' do
        let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}
        let(:name) {'John\'s Apartment'}

        example 'Apartment creation - Already in apartment' do
          explanation 'Attempting to create an apartment while already in one. The duplicate apartment will not be inserted into the database.'

          @existing_user.update_column(:apartment_id, @existing_apartment.id)
          # Now the request should fail
          do_request
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}
      let(:name) {'John\'s Apartment'}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Apartment creation - Not logged in' do
        explanation 'Attempt to delete an apartment while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end

  delete 'api/v1/apartments' do
    context '200' do
      example 'Apartment deletion' do
        explanation 'Delete the current user\'s apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)

        # Delete apartment
        do_request
        expect(status).to eq(200)

        # After the request, apt should be nil
        @existing_user.reload
        expect(@existing_user.apartment_id).to be nil
      end
    end

    context '400' do
      example_request 'Apartment deletion - Not already in apartment' do
        explanation 'Attempt to delete apartment while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Apartment deletion - Not logged in' do
        explanation 'Attempt to delete an apartment while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/apartments' do
    context '200' do
      example 'Get current apartment' do
        explanation 'Get details of the current user\'s apartment. The user must be part of an existing apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)

        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example_request 'Get current apartment - Not already in apartment' do
        explanation 'Attempt to get apartment while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Get current apartment - Not logged in' do
        explanation 'Attempt to get current apartment while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/issue_invite_email' do
    parameter :email, "The recipient's email.", type: :string

    context '200' do
      let(:email) {'jsmith@example.com'}
      example 'Issue invite email' do
        explanation 'Issue an invite to the recipient\'s email, which they can use to join the apartment.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:email) {'jsmith@example.com'}
      example_request 'Issue invite email - Not in apartment' do
        explanation 'Attempt to issue an invite email while user not already in apartment.'
        expect(status).to eq(400)
      end
    end
    context '401' do
      let(:email) {'jsmith@example.com'}

      let(:email_header) {nil}
      let(:password_header) {nil}
      example 'Issue invite email - Not logged in' do
        explanation 'Attempt to issue an invite email while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/update_description' do
    parameter :name, "The apartment's new name.", type: :string
    parameter :address, "The apartment's new address.", type: :string

    context '200' do
      example 'Update description' do
        explanation 'Update the current apartment\'s name and address.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :name => 'New Apartment Name',
            :address => 'New Address'
        }
        do_request(request)
        expect(status).to eq(200)
      end
      example 'Update description - Supply partial info' do
        explanation 'Update the current apartment\'s name or address only.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :name => 'New Apartment Name'
        }
        do_request(request)
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:name) {''}
      let(:address) {'New Address'}
      example_request 'Update description - Invalid' do
        explanation 'Supply invalid apartment name and/or address.'
        expect(status).to eq(400)
      end
    end
    context '401' do
      let(:name) {'New Apartment Name'}
      let(:address) {'New Address'}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Update description - Not logged in' do
        explanation 'Attempt to update the apartment description while supplying invalid user credentials.'
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/remove_user' do
    parameter :user_id, "The id of the user to remove.", type: :integer

    context '200' do
      let(:user_id) {@existing_user2.id}

      example 'Remove user' do
        explanation 'Remove another user from the apartment.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      let(:user_id) {@existing_user2.id}

      context 'invalid user' do
        example_request 'Remove user - Not in same apartment' do
          explanation 'Attempting to remove a user that isn\'t in the same apartment.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:user_id) {@existing_user2.id}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Remove user - Not logged in' do
        explanation 'Attempt to remove a user while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end
end