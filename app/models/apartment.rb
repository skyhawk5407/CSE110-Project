class Apartment < ApplicationRecord
  has_secure_token :access_code

  validates :address, :presence => true, :length => {:in => 2..128}
  validates :name, :presence => true, :length => {:in => 2..128}
end
