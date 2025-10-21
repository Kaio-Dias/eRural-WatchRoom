class Room < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :videos, dependent: :destroy

  validates :slug, presence: true, uniqueness: true
  validates :creator_nickname, presence: true

  before_validation :generate_slug, on: :create

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug ||= SecureRandom.hex(3)
  end
end