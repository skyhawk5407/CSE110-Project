# spec/acceptance/apartment_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Apartment' do
  explanation "Handles creation and updates to apartment."

  header "Content-Type", "application/json"

  header 'EMAIL', 'jsmith@example.com'
  header 'PASSWORD', 'password123'

  before (:each) do
    # Seed with an existing user and apartment
    @existing_user = User.create(
        :email => 'jsmith@example.com',
        :password => 'password123',
        :display_name => 'John Smith')

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

      example_request '1. Apartment creation - create a new apartment' do
        explanation 'Create a new apartment, providing all the necessary fields. The new apartment will be inserted into the database.\n Note: The user is not currently in an apartment.'
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'insufficient fields' do
        let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}

        example_request '2. Apartment creation - insufficient fields' do
          explanation 'Example of supplying insufficient information. The new apartment will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end

      context 'user is already in apartment' do
        let(:address) {'9500 Gilman Dr, La Jolla, CA 92093'}
        let(:name) {'John\'s Apartment'}

        example '3. Apartment creation - already in apartment' do
          explanation 'Attempting to create an apartment while already in one. The duplicate apartment will not be inserted into the database.'

          @existing_user.update_column(:apartment_id, @existing_apartment.id)
          # Now the request should fail
          do_request
          expect(status).to eq(400)
        end
      end
    end
  end
end