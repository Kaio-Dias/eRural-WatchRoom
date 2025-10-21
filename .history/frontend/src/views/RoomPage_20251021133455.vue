<template>
  <div class="room">
      <div class="sidebar" :class="{ collapsed: sidebarCollapsed }">
        <div class="sidebar-toggle" @click="toggleSidebar">
          <span>{{ sidebarCollapsed ? '▶' : '◀' }}</span>
        </div>
        <div class="user-info">
          <img src="https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png" alt="User Avatar">
          <span v-if="!sidebarCollapsed">User-LNUFF</span>
        </div>
        <div class="menu">
          <a href="#" @click="showParticipantsModal = true" :title="sidebarCollapsed ? 'Participantes' : ''">
            <span class="menu-icon">👥</span>
            <span v-if="!sidebarCollapsed">Participantes</span>
          </a>
        </div>
      </div>
        <div class="main-content">
          <div class="header">
            <div class="room-info">
              <div class="room-icon">🎬</div>
              <div class="room-details">
                <h1 class="room-name">{{ $route.params.slug }}</h1>
                <p class="room-subtitle">Sala de vídeo sincronizada</p>
              </div>
            </div>
            <div class="controls-bar">
              <div class="video-control">
                <div class="control-label">
                  <i class="fab fa-youtube"></i>
                  <span>YouTube URL</span>
                </div>
                <div class="input-group">
                  <input v-model="urlInput" @keyup.enter="submitUrl" type="text" class="url-input" placeholder="Cole uma URL do YouTube aqui...">
                  <button class="btn-change-video" @click="submitUrl" title="Trocar vídeo">
                    <i class="fas fa-play-circle"></i>
                    <span>Trocar</span>
                  </button>
                </div>
              </div>
              <div class="share-control">
                <button class="btn-copy-link" @click="copyRoomLink" title="Copiar link da sala">
                  <i class="fas fa-link"></i>
                  <span>Copiar Link</span>
                </button>
              </div>
            </div>
          </div>
      <div class="video-player" ref="videoContainer" style="position: relative;">
        <!-- YouTube Player -->
        <YouTubePlayer 
          :videoId="currentVideoId"
          ref="youtubePlayer"
          @play="onLocalPlay"
          @pause="onLocalPause"
        />
      </div>
      <!-- Emoji Overlay - Fora do container do vídeo -->
      <EmojiOverlay ref="emojiOverlay" />
      <div class="w2g-shorts">
        <div class="shorts-gallery">
          <!-- Galeria de salas -->
        </div>
      </div>
    </div>
    <div class="chat-panel">
      <!-- Chat Panel -->
      <ChatPanel 
        :messages="messages"
        @send="handleSendChat"
      />
    </div>
    
    <!-- Modal de Participantes -->
    <div v-if="showParticipantsModal" class="modal-overlay" @click="showParticipantsModal = false">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>👥 Participantes da Sala ({{ onlineParticipants }}/{{ participants.length }})</h3>
          <button class="close-btn" @click="showParticipantsModal = false">&times;</button>
        </div>
        <div class="participants-list">
          <div v-for="participant in participants" :key="participant.id" class="participant-item">
            <img :src="participant.avatar" :alt="participant.name" class="participant-avatar">
            <div class="participant-info">
              <div class="participant-name">{{ participant.name }}</div>
              <div class="participant-time">Entrou em {{ formatTime(participant.joinTime) }}</div>
            </div>
            <div class="status-indicator" :class="participant.status"></div>
          </div>
        </div>
        <div class="modal-footer">
          <p class="explanation">
            💡 <strong>Como funciona:</strong><br>
            Os participantes entram automaticamente quando acessam o link da sala.<br>
            Compartilhe o link para convidar mais pessoas!
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import YouTubePlayer from '../components/YouTubePlayer.vue';
import ChatPanel from '../components/ChatPanel.vue';
import EmojiOverlay from '../overlay/EmojiOverlay.vue';
import cable from '../services/cable';

export default {
  components: {
    YouTubePlayer,
    ChatPanel,
    EmojiOverlay
  },
  data() {
    return {
      currentVideoId: 'dQw4w9WgXcQ',
      messages: [],
      subscription: null,
      urlInput: '',
      localChangeLockUntil: 0,
      showParticipantsModal: false,
      sidebarCollapsed: false,
      participants: [
        { id: 1, name: 'Usuário Teste', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png', status: 'online', joinTime: new Date() },
        { id: 2, name: 'Alice Silva', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png', status: 'online', joinTime: new Date() },
        { id: 3, name: 'Bob Santos', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png', status: 'away', joinTime: new Date() },
        { id: 4, name: 'Carol Lima', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_3.png', status: 'online', joinTime: new Date() }
      ]
    };
  },
  computed: {
    roomSlug() {
      return this.$route.params.slug;
    },
    onlineParticipants() {
      return this.participants.filter(p => p.status === 'online').length;
    }
  },
  mounted() {
    console.log('RoomPage mounted for slug:', this.roomSlug);
    this.connectToRoom();
  },
  beforeUnmount() {
    console.log('RoomPage beforeUnmount');
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  },
  methods: {
    connectToRoom() {
      if (!this.subscription) {
        this.subscription = cable.subscriptions.create(
          { channel: 'RoomChannel', room_slug: this.roomSlug },
          {
            connected: () => {
              console.log('Connected to room:', this.roomSlug);
            },
            disconnected: () => {
              console.log('Disconnected from room');
            },
            received: (data) => {
              this.onCableReceived(data);
            }
          }
        );
      }
    },
    onCableReceived(data) {
      console.log('Received ActionCable data:', data);
      
      switch (data.type) {
        case 'video:state':
          this.onVideoStateUpdate(data.payload);
          break;
        case 'chat:history':
          this.messages = data.payload.messages || [];
          break;
        case 'chat:message':
          this.messages.push(data.payload);
          break;
        case 'emoji:burst':
          this.onEmojiBurst(data.payload);
          break;
      }
    },
    onVideoStateUpdate(payload) {
      console.log('onVideoStateUpdate called with:', payload);
      
      if (this.localChangeLockUntil > Date.now()) {
        console.log('Ignoring update due to local change lock');
        return; // Ignore updates during local changes
      }
      
      console.log('Current video ID:', this.currentVideoId);
      console.log('Payload video_id:', payload.video_id);
      console.log('Are they different?', payload.video_id !== this.currentVideoId);
      
      if (payload.video_id && payload.video_id !== this.currentVideoId) {
        console.log('Video ID changed from', this.currentVideoId, 'to', payload.video_id);
        this.currentVideoId = payload.video_id;
        // Carregar o novo vídeo no player
        if (this.$refs.youtubePlayer) {
          console.log('Calling load method on YouTubePlayer');
          this.$refs.youtubePlayer.load(payload.video_id, payload.video_time_seconds || 0);
        } else {
          console.log('YouTubePlayer ref not found');
        }
      } else {
        console.log('Video ID not changed or invalid');
      }
      
      if (this.$refs.youtubePlayer) {
        if (payload.is_paused) {
          this.$refs.youtubePlayer.pause();
        } else {
          this.$refs.youtubePlayer.play();
        }
        
        if (payload.video_time_seconds !== undefined) {
          this.$refs.youtubePlayer.seekTo(payload.video_time_seconds);
        }
      }
    },
    onLocalPlay(data) {
      if (this.localChangeLockUntil > Date.now()) return;
      
      this.localChangeLockUntil = Date.now() + 1000; // 1 second lock
      
      if (this.subscription) {
        this.subscription.perform('video_play', {
          payload: { videoTimeSeconds: data.currentTime }
        });
      }
    },
    onLocalPause(data) {
      if (this.localChangeLockUntil > Date.now()) return;
      
      this.localChangeLockUntil = Date.now() + 1000; // 1 second lock
      
      if (this.subscription) {
        this.subscription.perform('video_pause', {
          payload: { videoTimeSeconds: data.currentTime }
        });
      }
    },
    handleSendChat(message) {
      if (this.subscription) {
        this.subscription.perform('chat_message', {
          payload: {
            text: message.text,
            user: 'User-LNUFF'
          }
        });
      }
    },
    submitUrl() {
      const raw = this.urlInput.trim();
      if (!raw) return;
      
      console.log('URL submitted:', raw);
      
      if (this.subscription) {
        this.subscription.perform('video_load', {
          payload: { videoId: raw }
        });
      }
      
      this.urlInput = '';
    },
    copyRoomLink() {
      const slug = this.roomSlug;
      const url = `${window.location.origin}/rooms/${slug}`;
      navigator.clipboard.writeText(url);
      
      // Toast notification
      this.showToast('Link copiado para a área de transferência!');
      
      console.log('Link copiado:', url);
    },
    onEmojiBurst(payload) {
      console.log('Emoji burst received:', payload);
      if (this.$refs.emojiOverlay) {
        this.$refs.emojiOverlay.burst(payload);
      }
    },
    showToast(message) {
      // Simple toast implementation
      const toast = document.createElement('div');
      toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #333;
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        z-index: 10001;
        font-size: 14px;
        opacity: 0;
        transition: opacity 0.3s ease;
      `;
      toast.textContent = message;
      document.body.appendChild(toast);
      
      // Fade in
      setTimeout(() => {
        toast.style.opacity = '1';
      }, 10);
      
      // Fade out and remove
      setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => {
          document.body.removeChild(toast);
        }, 300);
      }, 2000);
    },
        formatTime(date) {
          return date.toLocaleTimeString('pt-BR', { 
            hour: '2-digit', 
            minute: '2-digit' 
          });
        },
        toggleSidebar() {
          this.sidebarCollapsed = !this.sidebarCollapsed;
        }
  }
};
</script>

<style scoped>
.room {
  display: flex;
  height: 100vh;
  background-color: #181818;
  color: white;
}

/* Sidebar */
.sidebar {
  width: 240px;
  background-color: #202020;
  padding: 20px;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  position: relative;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
}

.sidebar.collapsed {
  width: 70px;
  padding: 20px 10px;
}

.sidebar-toggle {
  position: absolute;
  top: 20px;
  right: -15px;
  width: 30px;
  height: 30px;
  background-color: #333;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: white;
  font-size: 12px;
  transition: all 0.3s ease;
  z-index: 1000;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.sidebar-toggle:hover {
  background-color: #444;
  transform: scale(1.1);
}

.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  padding-top: 10px;
}

.user-info img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
  flex-shrink: 0;
}

.sidebar.collapsed .user-info {
  justify-content: center;
}

.sidebar.collapsed .user-info img {
  margin-right: 0;
}

.menu a {
  display: flex;
  align-items: center;
  color: white;
  text-decoration: none;
  padding: 12px 10px;
  margin-bottom: 5px;
  border-radius: 8px;
  transition: background-color 0.2s ease, color 0.2s ease;
}

.menu a:hover {
  background-color: #333;
  color: #ffc107;
}

.menu a .menu-icon {
  margin-right: 10px;
  font-size: 1.2em;
  flex-shrink: 0;
}

.sidebar.collapsed .menu a {
  justify-content: center;
  padding: 12px 0;
}

.sidebar.collapsed .menu a .menu-icon {
  margin-right: 0;
}

/* Main content */
.main-content {
  flex-grow: 1;
  padding: 20px;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  overflow: hidden;
}

.header {
  margin-bottom: 25px;
}

.room-info {
  display: flex;
  align-items: center;
  gap: 20px;
  margin-bottom: 25px;
}

.room-icon {
  font-size: 3rem;
  background: linear-gradient(135deg, #ff6b6b, #feca57);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: bounce 2s infinite;
}

.room-details {
  flex: 1;
}

.room-name {
  font-size: 2.2rem;
  font-weight: 700;
  color: white;
  margin: 0 0 5px 0;
  background: linear-gradient(135deg, #ff6b6b, #feca57, #48dbfb);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.room-subtitle {
  color: rgba(255, 255, 255, 0.7);
  font-size: 1rem;
  margin: 0;
  font-weight: 300;
}

.controls-bar {
  display: flex;
  gap: 20px;
  align-items: flex-end;
  background: rgba(255, 255, 255, 0.05);
  padding: 20px;
  border-radius: 15px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.video-control {
  flex: 1;
}

.control-label {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
  font-size: 0.9rem;
}

.control-label i {
  color: #ff0000;
  font-size: 1.1rem;
}

.input-group {
  display: flex;
  gap: 12px;
  align-items: center;
}

.url-input {
  flex: 1;
  padding: 15px 20px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 14px;
  outline: none;
  transition: all 0.3s ease;
}

.url-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.url-input:focus {
  background: rgba(255, 255, 255, 0.1);
  border-color: #ff6b6b;
  box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.2);
}

.share-control {
  display: flex;
  align-items: center;
}

.btn-change-video, .btn-copy-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-change-video {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
}

.btn-change-video:hover {
  background: linear-gradient(135deg, #ff5252, #d63031);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
}

.btn-copy-link {
  background: linear-gradient(135deg, #74b9ff, #0984e3);
  color: white;
  box-shadow: 0 4px 15px rgba(116, 185, 255, 0.3);
}

.btn-copy-link:hover {
  background: linear-gradient(135deg, #0984e3, #74b9ff);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(116, 185, 255, 0.4);
}

.btn-change-video i, .btn-copy-link i {
  font-size: 16px;
}

/* Video Player Area */
.video-player {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: black;
  border-radius: 8px;
  overflow: hidden;
  aspect-ratio: 16 / 9;
  max-height: 75vh;
}

.video-player iframe {
  width: 100%;
  height: 100%;
  border: none;
  object-fit: cover;
}

/* Shorts section */
.w2g-shorts {
  margin-top: 15px;
  text-align: center;
}

.w2g-shorts h3 {
  margin-bottom: 10px;
}

/* Chat */
.chat-panel {
  width: 350px;
  background-color: #202020;
  display: flex;
  flex-direction: column;
}

/* Modal de Participantes */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  z-index: 10000;
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background-color: #2a2a2a;
  border-radius: 8px;
  padding: 0;
  min-width: 400px;
  max-width: 500px;
  max-height: 80vh;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #444;
}

.modal-header h3 {
  margin: 0;
  color: white;
  font-size: 18px;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 30px;
  height: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background-color: #444;
  border-radius: 4px;
}

.participants-list {
  max-height: 400px;
  overflow-y: auto;
  padding: 10px 0;
}

.participant-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  border-bottom: 1px solid #333;
  transition: background-color 0.2s;
}

.participant-item:hover {
  background-color: #333;
}

.participant-item:last-child {
  border-bottom: none;
}

.participant-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 12px;
}

.participant-info {
  flex-grow: 1;
}

.participant-name {
  font-weight: bold;
  color: white;
  margin-bottom: 2px;
}

.participant-time {
  font-size: 12px;
  color: #ccc;
}

.status-indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-left: 10px;
}

.status-indicator.online {
  background-color: #28a745;
}

.status-indicator.away {
  background-color: #ffc107;
}

.status-indicator.offline {
  background-color: #dc3545;
}

.modal-footer {
  padding: 20px;
  background-color: #333;
  border-top: 1px solid #444;
}

  .explanation {
    margin: 0;
    color: #ccc;
    font-size: 14px;
    line-height: 1.4;
  }

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-10px); }
  60% { transform: translateY(-5px); }
}
</style>