EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

class User < ApplicationRecord
  has_many :expenses

  has_secure_password
  has_secure_token :reset_token

  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :reset_token, :uniqueness => true
  validates :display_name, :presence => true, :length => { :in => 2..64 }
  validates :password, :presence => true, :length => { :in => 5..128 }, :if => :password_digest_changed?

  def update_password(new_password)
    self.update(password: new_password)
    self.regenerate_reset_token
  end

  def as_json(options = {})
    super(except: [:password_digest, :reset_token])
  end
end
