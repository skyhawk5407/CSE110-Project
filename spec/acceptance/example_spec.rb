# spec/acceptance/example_spec.rb

require 'rails_helper'
require 'rspec_api_documentation/dsl'
resource 'Example' do
  explanation "Documentation example"

  header "Content-Type", "application/json"

  post 'api/v1/example' do
    parameter :name, "The user's name.", type: :string

    context '200' do
      let(:name) {'John'}
      example_request 'Example' do
        explanation 'Display a greeting message'
        expect(status).to eq(200)
      end
    end

    context '400' do
      let(:name) {nil}
      example_request 'Example - bad request' do
        explanation 'If no name is specified, display an error.'
        expect(status).to eq(400)
      end
    end
  end
end