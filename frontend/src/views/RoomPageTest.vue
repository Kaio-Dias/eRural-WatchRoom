<template>
  <div class="room-test">
    <h1>Teste da Sala: {{ $route.params.slug }}</h1>
    <p>Esta é uma versão de teste da página da sala.</p>
    <button @click="showParticipantsModal = true">Testar Modal de Participantes</button>
    
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
      showParticipantsModal: false,
      participants: [
        { id: 1, name: 'Usuário Teste', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_5.png', status: 'online', joinTime: new Date() },
        { id: 2, name: 'Alice Silva', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_1.png', status: 'online', joinTime: new Date() },
        { id: 3, name: 'Bob Santos', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_2.png', status: 'away', joinTime: new Date() },
        { id: 4, name: 'Carol Lima', avatar: 'https://cdn.jsdelivr.net/gh/alohe/avatars/png/vibrent_3.png', status: 'online', joinTime: new Date() }
      ]
    };
  },
  computed: {
    onlineParticipants() {
      return this.participants.filter(p => p.status === 'online').length;
    }
  },
  methods: {
    formatTime(date) {
      return date.toLocaleTimeString('pt-BR', { 
        hour: '2-digit', 
        minute: '2-digit' 
      });
    }
  }
};
</script>

<style scoped>
.room-test {
  padding: 20px;
  background-color: #181818;
  color: white;
  min-height: 100vh;
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
