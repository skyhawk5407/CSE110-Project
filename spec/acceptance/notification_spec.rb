# spec/acceptance/apartment_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Notifications' do
  explanation "Handles creation and updates to apartment notifications."

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
    @existing_notification = Notification.create(
        :apartment_id => @existing_apartment.id,
        :user_id => @existing_user2.id,
        :title => 'Notification 1',
        :message => 'Hello',
        :created_at => 10.days.ago
    )
    @existing_notification2 = Notification.create(
        :apartment_id => @existing_apartment.id,
        :user_id => nil,
        :title => 'Notification 2',
        :message => 'Hello again',
        :created_at => 1.days.ago
    )
  end

  post 'api/v1/apartments/notifications' do
    parameter :title, 'The title of the notification.', type: :string
    parameter :message, 'The message content of the notification', type: :string

    context '200' do
      let(:title) {'Test Notification'}
      let(:message) {'Hi everyone'}
      example 'Notification creation' do
        explanation 'Send a notification to everyone in the apartment.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Invalid fields' do
        let(:message) {''}
        example 'Notification creation - Invalid fields' do
          explanation 'Example of supplying insufficient/invalid information. The notification will not be inserted into the database.'
          @existing_user.update(:apartment_id => @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:title) {'Test Notification'}
        let(:message) {'Hi everyone'}
        example_request 'Notification creation - Not part of apartment' do
          explanation 'Attempt to add a notification while not in an apartment. The new document will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:title) {'Test Notification'}
      let(:message) {'Hi everyone'}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example 'Notification creation - Not logged in' do
        explanation 'Attempt to create a document while not supplying correct user credentials.'
        @existing_user.apartment_id = @existing_apartment.id
        do_request
        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/apartments/notifications/all' do
    parameter :timestamp, 'Optional timestamp filter for notifications. If specified, only return notifications sent after the timestamp.', type: :string

    context '200' do
      example 'Get all notifications' do
        explanation 'Get all notifications belonging to the current user\'s apartment. The user must be part of an existing apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end

      example 'Get all notifications - specify timestamp' do
        explanation 'Get all notifications after the specified timestamp.'
        # User is part of apartment
        request = {
            :timestamp => 5.days.ago
        }
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request(request)
        expect(status).to eq(200)
      end
    end

    context '400' do
      example_request 'Get all notifications - Not already in apartment' do
        explanation 'Attempt to get notifications while user not already in apartment.'
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

  post 'api/v1/apartments/notifications/mark_read' do
    parameter :notification_ids, "The notifications to mark as read.", type: :array, items: :integer

    context '200' do
      let(:notification_ids) {[@existing_notification, @existing_notification2]}
      example 'Mark as read' do
        explanation 'Mark the selected notifications as read.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end
    context '400' do
      let(:notification_ids) {[@existing_notification, @existing_notification2]}
      example_request 'Mark as read - not in apartment' do
        explanation 'Attempt to mark notifications as read while not in an apartment.'
        expect(status).to eq(400)
      end
    end
    context '401' do
      let(:notification_ids) {[@existing_notification, @existing_notification2]}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Update description - Not logged in' do
        explanation 'Attempt to update the document while supplying invalid user credentials.'
        expect(status).to eq(401)
      end
    end
  end
end