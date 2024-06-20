class Album < ApplicationRecord
  belongs_to :user
  has_many :album_details,dependent: :destroy
end
