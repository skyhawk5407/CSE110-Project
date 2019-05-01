# https://blog.codeship.com/producing-documentation-for-your-rails-api/

# spec/acceptance/residences_spec.rb
require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Residences" do
  # let(:user) { create(:user) }
  # let(:auth_token) { user.auth_token }

  # Headers which should be included in the request
  header "Accept", "application/vnd.api+json"
  header "X-Api-Key", :auth_token

  # A specific endpoint
  get "/residences" do
    # Which GET/POST params can be included in the request and what do they do?
    parameter :sort, "Sort the response. They are comma separated and include - in front to sort in descending order. Example: -rooms,cost"
    parameter :number, "Which page number of results would you like.", scope: :page

    let(:number) { 1 }
    let(:sort) { "-rooms,cost" }

    # We can provide multiple examples for each endpoint, highlighting different aspects of them.
    example "(Example) Listing residences" do
      explanation "Retrieve all of the residences. They can be sorted, filtered and will be paginated."

      # 2.times { create(:residence, rooms: (1..6).to_a.sample) }

      # do_request

      # expect(status).to eq(200)
    end
  end
end