class ScheduledExpense < ApplicationRecord
  belongs_to :apartment
  belongs_to :payer
  belongs_to :issuer
end
