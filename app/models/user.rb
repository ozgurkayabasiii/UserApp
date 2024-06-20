class User < ApplicationRecord
  belongs_to :company, optional: true
  has_one :address
  has_many :albums, dependent: :destroy
  after_create :fetch_profile_pic

  validates :name, :username, :email, :phone, presence: true
  
  accepts_nested_attributes_for :address

  private
  
  def fetch_profile_pic
    response = HTTParty.get("https://picsum.photos/id/#{id}/info")
    if response.success?
      self.profile_pic = response.parsed_response["download_url"]
      save
    else
      errors.add(:profile_pic, "could not be fetched")
    end
  end

end
