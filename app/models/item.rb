class Item < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :apartment

  has_one_attached :image

  validates :apartment_id, :presence => true
  validates :image, blob: { content_type: :image }
  validates :name, :presence => true, :length => {:in => 1..128}
  validates :description, :presence => true, :length => {:in => 1..4096}

  def to_json(base_url)
    json = self.as_json
    json = json.merge({:owner_name => self.user.nil? ? 'N/A' : self.user.display_name})
    return json.merge({:url => nil, :file_data => nil}) if self.image.blank?

    ActiveStorage::Current.host = base_url
    json.merge({:url => self.image.blob.service_url,
                :file_name => self.image.filename,
                :file_data => Base64.encode64(self.image.download)})
  end
end
