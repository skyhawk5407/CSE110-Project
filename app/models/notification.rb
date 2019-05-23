class Notification < ApplicationRecord
  belongs_to :apartment, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
