<template>
  <div class="chat-container">
    <div class="messages">
      <div v-for="(message, idx) in messages" :key="message.id || idx" class="message">
        <strong>{{ message.user || message.author }}:</strong> {{ message.text }}
      </div>
    </div>
    <div class="emoji-buttons">
      <button class="emoji-btn" @click="sendEmoji('🔥')" title="Fire">🔥</button>
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
</template>

<script>
export default {
  props: {
    messages: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return { newMessage: '' };
  },
  emits: ['send'],
  methods: {
    onSend() {
      const text = this.newMessage.trim();
      if (!text) return;
      this.$emit('send', { text });
      this.newMessage = '';
    },
    sendEmoji(emoji) {
      this.$emit('send', { text: emoji });
    }
  }
};
</script>

<style scoped>
.chat-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  background-color: #202020;
  padding: 10px;
  color: white;
}

.messages {
  flex-grow: 1;
  overflow-y: auto;
  margin-bottom: 10px;
}

.message {
  margin-bottom: 5px;
}

.emoji-buttons {
  display: flex;
  gap: 8px;
  margin-bottom: 10px;
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
</style>