class Expense < ApplicationRecord
  belongs_to :apartment
  belongs_to :payer, :class_name => 'User'
  belongs_to :issuer, :class_name => 'User'
end
