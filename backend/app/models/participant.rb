class Participant < ApplicationRecord
  belongs_to :room
  has_many :messages, dependent: :destroy

  validates :nickname, presence: true
end
