# spec/acceptance/apartment_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Expense' do
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
    @existing_expense = Expense.create(
        :apartment_id => @existing_apartment.id,
        :payer_id => @existing_user.id,
        :issuer_id => @existing_user2.id,
        :title => 'Example expense 1',
        :description => 'Expense Description',
        :amount => 1234,
        :paid => false
    )
    @existing_expense2 = Expense.create(
        :apartment_id => @existing_apartment.id,
        :payer_id => @existing_user2.id,
        :issuer_id => @existing_user.id,
        :title => 'Example expense 2',
        :description => 'Expense Description',
        :amount => 1000,
        :paid => true
    )
    @existing_document = Document.create(
        :apartment_id => @existing_apartment.id,
        :user_id => @existing_user2.id,
        :expense_id => @existing_expense.id,
        :title => 'Example Document',
        :apartmentwide => false,
        :file_data => {:io => StringIO.new(@example_file), :filename => 'example_doc.txt'}
    )
  end

  post 'api/v1/apartments/expenses' do
    parameter :payer_id, 'The expense payer\'s user ID.', type: :integer
    parameter :issuer_id, 'The expense issuer\'s user ID.', type: :integer
    parameter :title, 'The name of the expense.', type: :string
    parameter :description, 'The description of the expense.', type: :string
    parameter :amount, 'The amount to be paid, in cents.', type: :integer

    context '200' do
      let(:payer_id) {@existing_user.id}
      let(:issuer_id) {@existing_user2.id}
      let(:title) {'Rent'}
      let(:description) {'January and February rent'}
      let(:amount) {100000}
      example 'Expense creation' do
        explanation 'Create a new expense.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        @existing_user2.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        let(:amount) {100000}
        example 'Expense creation - Insufficient fields' do
          explanation 'Example of supplying insufficient information. The new expense will not be inserted into the database.'
          @existing_user.update(:apartment_id => @existing_apartment.id)
          @existing_user2.update(:apartment_id => @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:payer_id) {@existing_user.id}
        let(:issuer_id) {@existing_user2.id}
        let(:title) {'Rent'}
        let(:description) {'January and February rent'}
        let(:amount) {100000}
        example_request 'Expense creation - Not part of apartment' do
          explanation 'Attempt to add a new expense while not in an apartment. The new expense will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end
      context 'Invalid fields' do
        let(:payer_id) {@existing_user.id}
        let(:issuer_id) {@existing_user2.id}
        let(:title) {'a'}
        let(:description) {''}
        let(:amount) {-500}
        example_request 'Expense creation - Invalid fields' do
          explanation 'Attempt to add a new expense with invalid fields. The new expense will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:payer_id) {@existing_user.id}
      let(:issuer_id) {@existing_user2.id}
      let(:title) {'Rent'}
      let(:description) {'January and February rent'}
      let(:amount) {100000}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Expense creation - Not logged in' do
        explanation 'Attempt to create an expense while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/apartments/expenses/all' do
    context '200' do
      example 'Get all expenses' do
        explanation 'Get all expenses belonging to the current user\'s apartment. The user must be part of an existing apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example_request 'Get all expenses - Not already in apartment' do
        explanation 'Attempt to get documents while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example 'Get all expenses - Not logged in' do
        explanation 'Attempt to get documents while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/expenses/mark_paid' do
    parameter :expense_id, 'The expense to update', type: :integer
    parameter :paid, 'The name of the expense.', type: :boolean

    context '200' do
      let(:expense_id) {@existing_expense.id}
      let(:paid) {true}
      let(:document_id) {@existing_document.id}
      example 'Mark as paid' do
        explanation 'Mark an expense as paid/unpaid. Additionally, optionally specify a document to attach.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        example 'Mark as paid - Insufficient fields' do
          explanation 'Example of supplying insufficient information.'
          @existing_user.update_column(:apartment_id, @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:expense_id) {@existing_expense.id}
        let(:paid) {true}
        let(:document_id) {@existing_document.id}
        example_request 'Mark as paid - Not part of apartment' do
          explanation 'Attempt to mark an expense as paid while not in an apartment.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:expense_id) {@existing_expense.id}
      let(:paid) {true}
      let(:document_id) {@existing_document.id}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Mark as paid - Not logged in' do
        explanation 'Attempt to mark an expense as paid while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  delete 'api/v1/apartments/expenses' do
    parameter :expense_id, 'The expense to delete', type: :integer

    context '200' do
      let(:expense_id) {@existing_expense.id}
      example 'Delete expense' do
        explanation 'Delete an expense. The corresponding document, if any, will also be deleted.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        example 'Delete expense - Insufficient fields' do
          explanation 'Example of supplying insufficient information.'
          @existing_user.update_column(:apartment_id, @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:expense_id) {@existing_expense.id}
        example_request 'Delete expense - Not part of apartment' do
          explanation 'Attempt to delete an expense while not in an apartment.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:expense_id) {@existing_expense.id}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Delete expense - Not logged in' do
        explanation 'Attempt to delete an expense while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end
end