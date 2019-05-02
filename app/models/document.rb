class Document < ApplicationRecord
  belongs_to :apartment
  belongs_to :expense
end
