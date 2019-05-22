class Document < ApplicationRecord
  belongs_to :apartment
  belongs_to :expense, optional: true

  has_one_attached :file_data
  #validates :file_data, attached: true

  def to_json(base_url)
    ActiveStorage::Current.host = base_url
    self.as_json.merge({:url => self.file_data.blob.service_url,
                       :file_data => Base64.encode64(self.file_data.download)})
  end

end
