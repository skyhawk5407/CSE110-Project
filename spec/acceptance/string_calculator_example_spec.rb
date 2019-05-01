# https://semaphoreci.com/community/tutorials/getting-started-with-rspec
# Example test specification
# Run tests with 'bundle exec rspec'

require "string_calculator_example"

describe StringCalculatorExample do

  describe ".add" do
    context "given an empty string" do
      it "returns zero" do
        expect(StringCalculatorExample.add("")).to eql(0)
      end
    end
  end
  
end
