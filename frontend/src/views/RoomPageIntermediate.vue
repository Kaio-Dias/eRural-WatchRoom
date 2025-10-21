<template>
  <div class="room">
    <div class="sidebar">
      <div class="user-info">
        <img src="https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png" alt="User Avatar">
        <span>User-LNUFF</span>
      </div>
      <div class="menu">
        <a href="#" @click="showParticipantsModal = true">👥 Participantes</a>
      </div>
    </div>
    <div class="main-content">
      <div class="header">
        <div class="room-name">Room: {{ $route.params.slug }}</div>
        <div class="search-bar">
          <input v-model="urlInput" @keyup.enter="submitUrl" type="text" class="form-control" placeholder="Search OR Paste a link to a Youtube video">
          <button class="btn btn-secondary" @click="submitUrl" title="Change video"><i class="fas fa-search"></i></button>
          <button class="btn btn-secondary" @click="copyRoomLink" title="Copy room link" style="margin-left:8px;">
            <i class="fas fa-share"></i>
          </button>
        </div>
      </div>
      <div class="video-player" ref="videoContainer" style="position: relative;">
        <div style="width: 100%; height: 100%; background-color: black; display: flex; align-items: center; justify-content: center; color: white;">
          <h2>Player do YouTube</h2>
        </div>
      </div>
      <div class="w2g-shorts">
        <div class="shorts-gallery">
          <!-- Galeria de salas -->
        </div>
      </div>
    </div>
    <div class="chat-panel">
      <div style="padding: 10px; color: white;">
        <h3>Chat</h3>
        <div v-for="(message, idx) in messages" :key="idx" class="message">
          <strong>{{ message.user || message.author }}:</strong> {{ message.text }}
        </div>
        <div class="emoji-buttons">
          <button class="emoji-btn" @click="sendEmoji('aa')" title="Fire">🔥</button>
          <button class="emoji-btn" @click="sendEmoji('😂')" title="Laughing">😂</button>
          <button class="emoji-btn" @click="sendEmoji('❤️')" title="Heart">❤️</button>
          <button class="emoji-btn" @click="sendEmoji('👏')" title="Clap">👏</button>
          <button class="emoji-btn" @click="sendEmoji('👍')" title="Thumbs Up">👍</button>
        </div>
        <div class="input-group">
          <input type="text" class="form-control" v-model="newMessage" @keyup.enter="onSend" placeholder="Type a message...">
          <button class="btn btn-secondary" @click="onSend">Send</button>
        </div>
      </div>
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
export default {
  data() {
    return {
      currentVideoId: 'dQw4w9WgXcQ',
      messages: [],
      urlInput: '',
      newMessage: '',
      showParticipantsModal: false,
      participants: [
        { id: 1, name: 'Usuário Teste', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png', status: 'online', joinTime: new Date() },
        { id: 2, name: 'Alice Silva', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png', status: 'online', joinTime: new Date() },
        { id: 3, name: 'Bob Santos', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png', status: 'away', joinTime: new Date() },
        { id: 4, name: 'Carol Lima', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_3.png', status: 'online', joinTime: new Date() }
      ]
    };
  },
  mounted() {
    console.log('RoomPage mounted for slug:', this.$route.params.slug);
  },
  computed: {
    onlineParticipants() {
      return this.participants.filter(p => p.status === 'online').length;
    }
  },
  beforeUnmount() {
    console.log('RoomPage beforeUnmount');
  },
  methods: {
    submitUrl() {
      const raw = this.urlInput.trim();
      if (!raw) return;
      console.log('URL submitted:', raw);
      this.urlInput = '';
    },
    copyRoomLink() {
      const slug = this.$route.params.slug;
      const url = `${window.location.origin}/rooms/${slug}`;
      navigator.clipboard.writeText(url);
      console.log('Link copiado:', url);
    },
    formatTime(date) {
      return date.toLocaleTimeString('pt-BR', { 
        hour: '2-digit', 
        minute: '2-digit' 
      });
    },
    sendEmoji(emoji) {
      console.log('Enviando emoji:', emoji);
      this.messages.push({
        text: emoji,
        user: 'Usuário',
        ts: Date.now()
      });
    },
    onSend() {
      const text = this.newMessage.trim();
      if (!text) return;
      this.messages.push({
        text: text,
        user: 'Usuário',
        ts: Date.now()
      });
      this.newMessage = '';
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
}

.user-info {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
}

.user-info img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin-right: 10px;
}

.menu a {
  display: block;
  color: white;
  text-decoration: none;
  padding: 10px 0;
}

.menu a i {
  margin-right: 10px;
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
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-bar {
  display: flex;
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

.message {
  margin-bottom: 5px;
}

.emoji-buttons {
  display: flex;
  gap: 8px;
  margin: 10px 0;
  justify-content: center;
}

.emoji-btn {
  background: none;
  border: 1px solid #555;
  border-radius: 4px;
  padding: 6px 10px;
  cursor: pointer;
  font-size: 16px;
  color: white;
  transition: background-color 0.2s;
}

.emoji-btn:hover {
  background-color: #333;
}

.input-group {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.form-control {
  flex: 1;
  padding: 8px;
  border: 1px solid #555;
  border-radius: 4px;
  background-color: #333;
  color: white;
}

.btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #545b62;
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
</style>
