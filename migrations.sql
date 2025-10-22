-- eRural Database Migrations
-- Este arquivo é usado como fallback caso bin/rails db:migrate falhe

-- Create rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id BIGSERIAL PRIMARY KEY,
    slug VARCHAR,
    creator_nickname VARCHAR,
    current_video_id VARCHAR,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE UNIQUE INDEX IF NOT EXISTS index_rooms_on_slug ON rooms(slug);

-- Create participants table
CREATE TABLE IF NOT EXISTS participants (
    id BIGSERIAL PRIMARY KEY,
    nickname VARCHAR,
    is_host BOOLEAN,
    room_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
CREATE INDEX IF NOT EXISTS index_participants_on_room_id ON participants(room_id);

-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
    id BIGSERIAL PRIMARY KEY,
    content TEXT,
    participant_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participant_id) REFERENCES participants(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
CREATE INDEX IF NOT EXISTS index_messages_on_participant_id ON messages(participant_id);
CREATE INDEX IF NOT EXISTS index_messages_on_room_id ON messages(room_id);

-- Create videos table
CREATE TABLE IF NOT EXISTS videos (
    id BIGSERIAL PRIMARY KEY,
    youtube_id VARCHAR,
    title VARCHAR,
    room_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
CREATE INDEX IF NOT EXISTS index_videos_on_room_id ON videos(room_id);

-- Insert migration records
INSERT INTO schema_migrations (version) VALUES 
    ('20251017202933'),
    ('20251017202955'),
    ('20251017203024'),
    ('20251017203046'),
    ('20251018215737')
ON CONFLICT DO NOTHING;

-- Summary
SELECT 'Migrations applied successfully' AS status;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;

