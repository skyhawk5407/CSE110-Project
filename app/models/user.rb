EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i

class User < ApplicationRecord
  has_many :expenses, foreign_key: 'payer_id', dependent: :destroy
  has_many :expenses, foreign_key: 'issuer_id', dependent: :destroy
  has_many :document, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :unread_notifications, dependent: :destroy
  has_many :items, dependent: :destroy

  belongs_to :apartment, optional: true

  has_secure_password
  has_secure_token :reset_token

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => EMAIL_REGEX
  validates :reset_token, :uniqueness => true
  validates :display_name, :presence => true, :length => { :in => 2..64 }
  validates :password, :presence => true, :length => { :in => 5..128 }, :if => :password_digest_changed?

  before_save :downcase_email

  def update_password(new_password)
    self.update(password: new_password)
    self.regenerate_reset_token
  end

  def as_json(options = {})
    super(except: [:password_digest, :reset_token])
  end

  def leave_apartment
    delete_expenses
    delete_items
    self.apartment_id = nil
  end

  private
  def delete_expenses
    Expense.where(:issuer_id => self.id).destroy_all
    Expense.where(:payer => self.id).destroy_all
  end

  def delete_items
    Item.where(:user_id => self.id).destroy_all
  end

  def downcase_email
    self.email = self.email.downcase
  end
end
