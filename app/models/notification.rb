class Notification < ApplicationRecord
  belongs_to :apartment
  belongs_to :user

  has_many :unread_notifications, dependent: :destroy

  validates :apartment_id, :presence => true
  validates :user_id, :presence => true
  validates :title, :presence => true, :length => { :in => 1..32 }
  validates :message, :presence => true, :length => { :in => 1..4096 }

  after_create :mark_unread

  def mark_unread
    users = User.where(:apartment_id => self.apartment_id)
    unread_notifications = []
    users.each do |user|
      next if user.id == self.user_id
      unread_notifications << UnreadNotification.new(
        :user_id => user.id,
        :notification_id => self.id
      )
    end
    UnreadNotification.import unread_notifications
  end
end
