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
      let(:email_header) {'jsmith@example.com'}
      let(:password) {'password123'}

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
end