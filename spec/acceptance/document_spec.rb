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
    @existing_user2 = User.create(
        :email => 'jdoe@example.com',
        :password => 'password12',
        :display_name => 'Jane Doe',
        :apartment_id => @existing_apartment.id
    )
    @example_file = File.open(File.join(Rails.root, 'public', 'robots.txt'), 'rb') {|io| io.read}
    @example_file_data = Base64.encode64(@example_file)
    @existing_document = Document.create(
        :apartment_id => @existing_apartment.id,
        :user_id => @existing_user2.id,
        :title => 'Example Document',
        :apartmentwide => false,
        :file_data => {:io => StringIO.new(@example_file), :filename => 'example_doc.txt'}
    )
  end

  post 'api/v1/apartments/documents/upload' do
    parameter :expense_id, 'The expense to link this document to, or null if N/A.', type: :integer
    parameter :title, 'The document title (name)', type: :string
    parameter :filename, 'The document filename', type: :string
    parameter :apartmentwide, 'Whether the document should be displayed in the apartment documents section', type: :boolean
    parameter :file_data, 'The base-64 encoding of the file to upload', type: :string

    context '200' do
      let(:expense_id) {nil}
      let(:title) {'Document Title'}
      let(:filename) {'robots.txt'}
      let(:apartmentwide) {true}
      let(:file_data) {@example_file_data}
      example 'Document creation' do
        explanation 'Create a new document consisting of a text document.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        let(:filename) {'robots.txt'}
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
        let(:filename) {'.png'}
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
      let(:filename) {'robots.txt'}
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

  get 'api/v1/apartments/documents/all' do
    context '200' do
      example 'Get all documents' do
        explanation 'Get all documents belonging to the current user\'s apartment. The user must be part of an existing apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example_request 'Get all documents - Not already in apartment' do
        explanation 'Attempt to get documents while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example 'Get all documents - Not logged in' do
        explanation 'Attempt to get documents while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/documents/update' do
    parameter :document_id, "The document's id.", type: :integer
    parameter :title, "The document's new title.", type: :string
    parameter :filename, "The document's new filename.", type: :string

    context '200' do
      example 'Update description' do
        explanation 'Update the current apartment\'s name and address.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :document_id => @existing_document.id,
            :title => 'New Document Title',
            :filename => 'new_filename.txt'
        }
        do_request(request)
        expect(status).to eq(200)
      end
      example 'Update description - Supply partial info' do
        explanation 'Update the current apartment\'s name or address only.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :document_id => @existing_document.id,
            :title => 'New Document Title'
        }
        do_request(request)
        expect(status).to eq(200)
      end

    end
    context '400' do
      context 'Invalid title/filename' do
        example 'Update description - Invalid title/filename' do
          explanation 'Supply invalid document title and/or filename.'
          request = {
              :document_id => @existing_document.id,
              :title => '',
              :filename => 'new_filename.txt'
          }
          do_request(request)
          expect(status).to eq(400)
        end
      end
      context 'No document ID' do
        example 'Update description - No document ID' do
          explanation 'Supply title and/or filename without supplying the document ID.'
          request = {
              :title => 'New Document Title',
              :filename => 'new_filename.txt'
          }
          do_request(request)
          expect(status).to eq(400)
        end
      end
    end
    context '401' do
      let(:document_id) {@existing_document.id}
      let(:title) {'New Document Title'}
      let(:filename) {'new_filename.txt'}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Update description - Not logged in' do
        explanation 'Attempt to update the document while supplying invalid user credentials.'
        expect(status).to eq(401)
      end
    end
  end

  delete 'api/v1/apartments/documents' do
    parameter :document_id, "The document's id.", type: :integer

    context '200' do
      let (:document_id) {@existing_document.id}
      example 'Document deletion' do
        explanation 'Delete the specified document. The current user must be a member of its corresponding apartment'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)

        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example 'Document deletion - Not in corresponding apartment' do
        explanation 'Attempt to delete document while user not member of corresponding apartment.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request({:document_id => @existing_document})
        expect(status).to eq(400)
      end
      example 'Document deletion - No document ID specified' do
        explanation 'Attempt to delete document while user not already in apartment.'
        do_request({:document_id => @existing_document})
        expect(status).to eq(400)
      end
    end

    context '400' do
      example_request 'Document deletion - Not already in apartment' do
        explanation 'Attempt to delete document while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Document deletion - Not logged in' do
        explanation 'Attempt to delete a document while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end
end