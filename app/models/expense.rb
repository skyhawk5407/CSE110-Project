class Expense < ApplicationRecord
  belongs_to :apartment
  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :issuer, class_name: 'User', foreign_key: 'issuer_id'
  has_one :document, dependent: :nullify

  validates :apartment_id, presence:true
  validates :issuer_id, presence:true
  validates :payer_id, presence:true
  validates :payer_id, exclusion: {in: ->(x) {[x.issuer_id]}}
  validates :amount, :numericality => {:greater_than => 0}
  validates :title, presence:true, :length => {in: 2..128}
  validates :description, presence:true, :length => {in: 1..4096}

end
