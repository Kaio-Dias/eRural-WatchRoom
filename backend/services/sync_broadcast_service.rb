require 'set'
class SyncBroadcastService
  @@room_states = {}
  @@room_presence = {}

  def self.store_for_room(room)
    @@room_states[room.id] ||= {
      video_state: {
        video_id: nil,
        is_paused: true,
        video_time_seconds: 0.0,
        last_updated_at: Time.now.utc
      },
      chat_messages: []
    }
  end

  def self.presence_for_room(room)
    @@room_presence[room.id] ||= Set.new
  end

  def self.snapshot_for(room)
    store = store_for_room(room)
    state = store[:video_state]
    return nil if state[:video_id].nil?

    {
      video_id: state[:video_id],
      is_paused: state[:is_paused],
      video_time_seconds: state[:video_time_seconds],
      server_time_ms: (Time.now.utc.to_f * 1000).to_i
    }
  end

  def self.update_video_state(room, partial_state)
    store = store_for_room(room)
    store[:video_state].merge!(partial_state)
    store[:video_state][:last_updated_at] = Time.now.utc
    RoomChannel.broadcast_to(room, {
      type: 'video:state',
      payload: snapshot_for(room)
    })
  end

  def self.append_chat(room, message)
    text = SanitizationService.sanitize_chat_text(message[:text])
    user = SanitizationService.sanitize_username(message[:user])
    
    return if text.blank?
    
    store = store_for_room(room)
    store[:chat_messages] << { text: text, user: user, ts: message[:ts] }
    
    store[:chat_messages] = store[:chat_messages].last(100)
    
    RoomChannel.broadcast_to(room, {
      type: 'chat:message',
      payload: { text: text, user: user, ts: message[:ts] }
    })
    
    emojis = extract_emojis(text)
    if emojis.any?
      emojis.each do |emoji|
        RoomChannel.broadcast_to(room, {
          type: 'emoji:burst',
          payload: { emoji: emoji, user: user, ts: message[:ts] }
        })
      end
    end
  end

  def self.join_room(room, client_id:, nickname: nil)
    set = presence_for_room(room)
    unless set.include?(client_id)
      set << client_id
      RoomChannel.broadcast_to(room, {
        type: 'presence:joined',
        payload: { client_id: client_id, nickname: nickname }
      })
    end
  end

  def self.leave_room(room, client_id:)
    set = presence_for_room(room)
    if set.delete?(client_id)
      RoomChannel.broadcast_to(room, {
        type: 'presence:left',
        payload: { client_id: client_id }
      })
    end
  end

  def self.list_presence(room)
    presence_for_room(room).to_a
  end

  def self.extract_emojis(text)
    emoji_pattern = /[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]/
    text.scan(emoji_pattern).uniq
  end

  def self.chat_history_for(room)
    store = store_for_room(room)
    store[:chat_messages]
  end

  def self.clear_room_state(room)
    @@room_states.delete(room.id)
  end

  def self.prune_old_rooms!(threshold = 24.hours.ago)
    @@room_states.delete_if do |_room_id, store|
      store[:video_state][:last_updated_at] < threshold
    end
  end

  def self.room_states_count
    @@room_states.size
  end

  def self.active_rooms
    @@room_states.keys.map { |id| Room.find_by(id: id) }.compact
  end
end