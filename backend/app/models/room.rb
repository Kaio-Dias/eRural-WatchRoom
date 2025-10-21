class Room < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :videos, dependent: :destroy

  before_create :generate_slug

  validates :creator_nickname, presence: true

  def current_video
    Video.find_by(youtube_id: current_video_id)
  end

  private

  def generate_slug
    # [AI Generated] Data: 21/10/2025
    # Descrição: Mantém slug fornecido; gera apenas se estiver em branco.
    # Gerado por: Cursor AI
    # AI_GENERATED_CODE_START
    self.slug ||= SecureRandom.hex(3)
    # AI_GENERATED_CODE_END
  end
end
