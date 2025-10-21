class Message < ApplicationRecord
  belongs_to :participant
  belongs_to :room

  validates :content, presence: true
end
