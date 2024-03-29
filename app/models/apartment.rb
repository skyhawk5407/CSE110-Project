class Apartment < ApplicationRecord
  has_secure_token :access_code

  has_many :users, dependent: :nullify
  has_many :expenses, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :address, :presence => true, :length => {:in => 2..128}
  validates :name, :presence => true, :length => {:in => 2..128}
end
