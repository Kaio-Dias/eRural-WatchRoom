# [AI Generated] Data: 21/10/2025
# Descrição: Gerencia estado em memória das salas e broadcast de eventos.
# Gerado por: Cursor AI
# AI_GENERATED_CODE_START
class SyncBroadcastService
  @@room_states = {}

  def self.store_for_room(room)
    @@room_states[room.id] ||= {
      video_state: {
        video_id: nil,
        is_paused: true,
        server_time_ms: Time.now.utc.to_i * 1000,
        video_time_seconds: 0.0
      },
      chat_history: [],
      emoji_counts: Hash.new { |h, k| h[k] = [] },
      emoji_cooldown_until: {}
    }
  end

  def self.update_video_state(room, updates)
    s = store_for_room(room)
    updates[:server_time_ms] = Time.now.utc.to_i * 1000
    s[:video_state].merge!(updates)
    RoomChannel.broadcast_to(room, { type: 'video:state', payload: s[:video_state] })
  end

  def self.snapshot_for(room)
    s = store_for_room(room)
    s[:video_state].dup
  end

  def self.chat_history_for(room)
    s = store_for_room(room)
    s[:chat_history].dup
  end

  # [AI Generated] Data: 21/10/2025
  # Descrição: Sanitiza texto/usuário, valida vazio, mantém histórico e dispara emoji burst.
  # Gerado por: Cursor AI
  # AI_GENERATED_CODE_START
  def self.append_chat(room, message)
    text = SanitizationService.sanitize_chat_text(message[:text])
    return if text.blank?

    user = SanitizationService.sanitize_user_name(message[:user])
    msg = {
      text: text,
      user: user,
      ts: (message[:ts] || Time.now.utc.to_i).to_i
    }

    s = store_for_room(room)
    s[:chat_history] << msg
    s[:chat_history].shift if s[:chat_history].length > 50

    RoomChannel.broadcast_to(room, { type: 'chat:message', payload: msg })

    # emoji bursts (usa o texto já sanitizado)
    emojis = extract_emojis(msg[:text])
    Rails.logger.info "Chat message: '#{text}', detected emojis: #{emojis.inspect}"
    emojis.each do |emoji|
      track_and_maybe_burst(room, emoji)
    end
  end
  # AI_GENERATED_CODE_END

  def self.extract_emojis(text)
    # Regex mais simples para capturar emojis comuns
    # Testa com emojis específicos: 🔥, 😂, ❤️, 👏, 👍
    emojis = []
    text.to_s.each_char do |char|
      # Verifica se o caractere é um emoji (Unicode range)
      if char.ord > 127 && char.match?(/[\u{1F300}-\u{1F9FF}\u{2600}-\u{27BF}]/)
        emojis << char
      end
    end
    emojis
  end

  def self.track_and_maybe_burst(room, emoji)
    s = store_for_room(room)
    now = Time.now.utc
    window = 10 # seconds
    cooldown = 5 # seconds

    timestamps = s[:emoji_counts][emoji]
    timestamps << now
    # purge outside window
    timestamps.select! { |t| (now - t) <= window }

    Rails.logger.info "Emoji '#{emoji}' count in window: #{timestamps.length}"

    cooldown_until = s[:emoji_cooldown_until][emoji]
    if cooldown_until && cooldown_until > now
      Rails.logger.info "Emoji '#{emoji}' in cooldown until #{cooldown_until}"
      return
    end

    if timestamps.length >= 3
      Rails.logger.info "Triggering emoji burst for '#{emoji}' with count #{timestamps.length}"
      s[:emoji_cooldown_until][emoji] = now + cooldown
      RoomChannel.broadcast_to(room, { type: 'emoji:burst', payload: { emoji: emoji, count: timestamps.length, serverTimeMs: (now.to_f * 1000).to_i } })
    end
  end
end
# AI_GENERATED_CODE_END