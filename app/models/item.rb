class Item < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :apartment, dependent: :destroy
end
