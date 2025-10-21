module SanitizationService
  extend self

  MAX_CHAT_LENGTH = 500
  MAX_USERNAME_LENGTH = 50

  def sanitize_chat_text(text)
    return '' if text.blank?
    
    text = text.to_s.strip
    text = text.truncate(MAX_CHAT_LENGTH, omission: '...')
    text
  end

  def sanitize_username(username)
    return 'Anonymous' if username.blank?
    
    username = username.to_s.strip
    username = username.truncate(MAX_USERNAME_LENGTH, omission: '...')
    username.presence || 'Anonymous'
  end
end