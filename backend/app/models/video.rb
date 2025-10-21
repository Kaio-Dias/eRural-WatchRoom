class Video < ApplicationRecord
  belongs_to :room

  validates :youtube_id, presence: true
end
