class Expense < ApplicationRecord
  belongs_to :apartment, dependent: :destroy
  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id', dependent: :destroy
  belongs_to :issuer, class_name: 'User', foreign_key: 'issuer_id', dependent: :destroy
  has_one :document, dependent: :nullify

  validates :amount, :numericality => {:greater_than => 0}
  validates :payer_id, exclusion: {in: ->(x) {[x.issuer_id]}}
  validates :title, :length => {in: 2..128}
end
