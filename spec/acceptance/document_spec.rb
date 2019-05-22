# spec/acceptance/apartment_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Document' do
  explanation "Handles creation and updates to apartment documents."

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

    @example_file = File.open(File.join(Rails.root, 'public', 'favicon.png'), 'rb') {|io| io.read}
    @example_file_data = Base64.encode64(@example_file)
  end

  post 'api/v1/apartments/documents/upload' do
    parameter :expense_id, 'The expense to link this document to, or null if N/A.', type: :integer
    parameter :title, 'The document title (name)', type: :string
    parameter :filename, 'The document filename', type: :string
    parameter :apartmentwide, 'Whether the document should be displayed in the apartment documents section', type: :boolean
    parameter :file_data, 'The base-64 encoding of the file to upload', type: :string

    context '200' do
      let(:expense_id) {nil}
      let(:title) {'My Document'}
      let(:filename) {'turdmate.png'}
      let(:apartmentwide) {true}
      let(:file_data) {@example_file_data}
      example 'Document creation' do
        explanation 'Create a new document consisting of an image.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        let(:filename) {'turdmate.png'}
        example 'Document creation - Insufficient fields' do
          explanation 'Example of supplying insufficient information. The new document will not be inserted into the database.'
          @existing_user.update(:apartment_id => @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:expense_id) {nil}
        let(:title) {'My Document'}
        let(:filename) {'turdmate.png'}
        let(:apartmentwide) {true}
        let(:file_data) {@example_file_data}
        example_request 'Document creation - Not part of apartment' do
          explanation 'Attempt to add a new document while not in an apartment. The new document will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:expense_id) {nil}
      let(:title) {'My Document'}
      let(:filename) {'turdmate.png'}
      let(:apartmentwide) {true}
      let(:file_data) {@example_file_data}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Document creation - Not logged in' do
        explanation 'Attempt to create a document while not supplying correct user credentials.'
        @existing_user.apartment_id = @existing_apartment.id
        do_request
        expect(status).to eq(401)
      end
    end
  end
end