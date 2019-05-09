EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

class User < ApplicationRecord
  has_many :expenses

  has_secure_password

  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :reset_token, :presence => true, :uniqueness => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :password, :length => { :in => 5..128 }

  def update_password(new_password)
    self.update(password: new_password)
    self.update(reset_token: SecureRandom.uuid)
  end
end
