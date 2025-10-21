class RoomChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find_by(slug: params[:room_slug])
    
    unless @room
      @room = Room.create!(slug: params[:room_slug], creator_nickname: 'Anon')
    end
    
    reject unless @room
    stream_for(@room)

    # Presença: marca entrada do cliente
    if connection.respond_to?(:client_id)
      SyncBroadcastService.join_room(@room, client_id: connection.client_id)
    end

    snapshot = SyncBroadcastService.snapshot_for(@room)
    transmit({ type: 'video:state', payload: snapshot }) if snapshot

    history = SyncBroadcastService.chat_history_for(@room)
    transmit({ type: 'chat:history', payload: { messages: history } }) if history
  end

  def unsubscribed
    # Presença: marca saída do cliente
    if @room && connection.respond_to?(:client_id)
      SyncBroadcastService.leave_room(@room, client_id: connection.client_id)
    end
  end

  def video_load(data)
    guard_room!
    raw = data.dig('payload', 'videoId').to_s
    Rails.logger.info "video_load received raw: #{raw}"
    
    video_id = valid_youtube_id?(raw) ? raw : (YouTube::ParserService.extract_id(raw) rescue nil)
    Rails.logger.info "Extracted video_id: #{video_id}"
    
    unless valid_youtube_id?(video_id)
      Rails.logger.info "Invalid video_id: #{video_id}"
      return
    end

    Rails.logger.info "Updating video state with video_id: #{video_id}"
    SyncBroadcastService.update_video_state(@room, {
      video_id: video_id,
      is_paused: true,
      video_time_seconds: 0.0
    })
  end

  def video_play(data)
    guard_room!
    t = (data.dig('payload', 'videoTimeSeconds') || 0).to_f
    SyncBroadcastService.update_video_state(@room, {
      is_paused: false,
      video_time_seconds: t
    })
  end

  def video_pause(data)
    guard_room!
    t = (data.dig('payload', 'videoTimeSeconds') || 0).to_f
    SyncBroadcastService.update_video_state(@room, {
      is_paused: true,
      video_time_seconds: t
    })
  end

  def video_seek(data)
    guard_room!
    to = (data.dig('payload', 'toVideoTimeSeconds') || 0).to_f
    SyncBroadcastService.update_video_state(@room, {
      video_time_seconds: to
    })
  end

  def chat_message(data)
    guard_room!
    text = data.dig('payload', 'text').to_s.strip
    user = data.dig('payload', 'user').to_s.strip
    return if text.blank?

    Rails.logger.info "Received chat message: '#{text}' from user '#{user}'"
    SyncBroadcastService.append_chat(@room, {
      text: text,
      user: user,
      ts: Time.now.utc.to_i
    })
  end

  private

  def guard_room!
    raise 'Not subscribed to room' unless @room
  end

  def valid_youtube_id?(id)
    !!(id.to_s =~ /\A[a-zA-Z0-9_-]{11}\z/)
  end
end
