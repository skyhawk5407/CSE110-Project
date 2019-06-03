# spec/acceptance/item_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Item' do
  explanation "Handles creation and updates to apartment items."

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
    @example_file = File.open(File.join(Rails.root, 'public', 'apple-touch-icon.png'), 'rb') {|io| io.read}
    @example_file_data = Base64.encode64(@example_file)
    @existing_item = Item.create(
        :apartment_id => @existing_apartment.id,
        :user_id => @existing_user2.id,
        :name => 'Microwave',
        :bought => true,
        :description => 'J Smith\'s microwave',
        :image => {:io => StringIO.new(@example_file), :filename => 'example_item.png'}
    )
  end

  post 'api/v1/apartments/items' do
    parameter :owner_id, 'The item\'s owner', type: :integer
    parameter :name, 'The item name', type: :string
    parameter :description, 'The item description', type: :string
    parameter :bought, 'Whether the item has been bought', type: :boolean
    parameter :image_data, 'Optional base-64 encoded image for the item', type: :string
    parameter :filename, 'If image_data is supplied, this is the filename of the attached image.', type: :string

    context '200' do
      example 'Item creation - Add optional image' do
        explanation 'Create a new item with an attached image.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        request = {
          :owner_id => nil,
          :name => 'Fridge',
          :description => 'We need a fridge for the apartment.',
          :bought => false,
          :image_data => @example_file_data,
          :filename => 'item.png'
        }
        do_request(request)
        expect(status).to eq(200)
      end
      example 'Item creation' do
        explanation 'Create a new item with no image.'
        @existing_user.update(:apartment_id => @existing_apartment.id)
        request = {
            :owner_id => nil,
            :name => 'Fridge',
            :description => 'We need a fridge for the apartment.',
            :bought => false
        }
        do_request(request)
        expect(status).to eq(200)
      end
    end

    context '400' do
      context 'Insufficient fields' do
        example 'Item creation - Insufficient fields' do
          explanation 'Example of supplying insufficient information. The new item will not be inserted into the database.'
          @existing_user.update(:apartment_id => @existing_apartment.id)
          do_request
          expect(status).to eq(400)
        end
      end
      context 'Not part of apartment' do
        let(:owner_id) {@existing_user.id}
        let(:name) {'Fridge'}
        let(:description) {'We need a fridge for the apartment.'}
        let(:bought) {false}
        example_request 'Item creation - Not part of apartment' do
          explanation 'Attempt to add a new item while not in an apartment. The new item will not be inserted into the database.'
          expect(status).to eq(400)
        end
      end
    end

    context '401' do
      let(:owner_id) {@existing_user.id}
      let(:name) {'Fridge'}
      let(:description) {'We need a fridge for the apartment.'}
      let(:bought) {false}

      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Item creation - Not logged in' do
        explanation 'Attempt to create a item while not supplying correct user credentials.'
        @existing_user.apartment_id = @existing_apartment.id
        do_request
        expect(status).to eq(401)
      end
    end
  end

  get 'api/v1/apartments/items/all' do
    context '200' do
      example 'Get all items' do
        explanation 'Get all items belonging to the current user\'s apartment. The user must be part of an existing apartment.'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example_request 'Get all items - Not already in apartment' do
        explanation 'Attempt to get items while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example 'Get all items - Not logged in' do
        explanation 'Attempt to get items while not supplying correct user credentials.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request
        expect(status).to eq(401)
      end
    end
  end

  post 'api/v1/apartments/items/update' do
    parameter :item_id, "The item's id.", type: :integer
    parameter :owner_id, "The item's new owner.", type: :integer
    parameter :name, "The item's new name.", type: :string
    parameter :description, "The item's new description.", type: :string
    parameter :bought, "Whether the item has been bought.", type: :boolean
    parameter :image_data, "Optionally include the item's updated image.", type: :string
    parameter :filename, "If image_data is included, the image's new filename.", type: :string

    context '200' do
      example 'Update description' do
        explanation 'Update all of the item\'s fields.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :item_id => @existing_item.id,
            :owner_id => @existing_user.id,
            :name => 'New Item Name',
            :name => 'New Item Description',
            :bought => true,
            :image_data => @example_file_data,
            :filename => 'new_filename.png'
        }
        do_request(request)
        expect(status).to eq(200)
      end
      example 'Update description - Supply partial info' do
        explanation 'Update only some of the item\'s fields.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        request = {
            :item_id => @existing_item.id,
            :bought => true,
            :image_data => @example_file_data,
            :filename => 'new_filename.png'
        }
        do_request(request)
        expect(status).to eq(200)
      end

    end
    context '400' do
      example 'Update item - Invalid parameter' do
        explanation 'Supply invalid item parameter.'
        request = {
            :item_id => -1,
            :owner_id => -1,
            :name => '',
            :bought => true
        }
        do_request(request)
        expect(status).to eq(400)
      end
    end
    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example 'Update description - Not logged in' do
        explanation 'Attempt to update the item while supplying invalid user credentials.'
        request = {
            :item_id => @existing_item.id,
            :owner_id => @existing_user.id,
            :name => 'New Item Name',
            :bought => true,
            :image_data => @example_file_data,
            :filename => 'new_filename.png'
        }
        do_request(request)
        expect(status).to eq(401)
      end
    end
  end

  delete 'api/v1/apartments/items' do
    parameter :item_id, "The item's id.", type: :integer

    context '200' do
      let (:item_id) {@existing_item.id}
      example 'Item deletion' do
        explanation 'Delete the specified item. The current user must be a member of its corresponding apartment'
        # User is part of apartment
        @existing_user.update_column(:apartment_id, @existing_apartment.id)

        do_request
        expect(status).to eq(200)
      end
    end

    context '400' do
      example 'Item deletion - Not in corresponding apartment' do
        explanation 'Attempt to delete item while user not member of corresponding apartment.'
        @existing_user.update_column(:apartment_id, @existing_apartment.id)
        do_request({:item_id => @existing_item})
        expect(status).to eq(400)
      end
      example 'Item deletion - No item ID specified' do
        explanation 'Attempt to delete apartment while user not already in apartment.'
        do_request({:item_id => @existing_item})
        expect(status).to eq(400)
      end
    end



    context '400' do
      example_request 'Item deletion - Not already in apartment' do
        explanation 'Attempt to delete apartment while user not already in apartment.'
        expect(status).to eq(400)
      end
    end

    context '401' do
      let(:email_header) {nil}
      let(:password_header) {nil}

      example_request 'Item deletion - Not logged in' do
        explanation 'Attempt to delete an apartment while not supplying correct user credentials.'
        expect(status).to eq(401)
      end
    end
  end
end