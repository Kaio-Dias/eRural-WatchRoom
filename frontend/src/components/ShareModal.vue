<template>
  <div class="modal-overlay" @click.self="close">
    <div class="modal-container">
      <div class="modal-content">
        <div class="modal-header">
          <div class="header-content">
            <div class="header-icon">🎬</div>
            <h5 class="modal-title">Crie sua sala</h5>
          </div>
          <button type="button" class="btn-close" @click="close">
            <span>&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="input-section">
            <label class="input-label">Adicione um apelido</label>
            <input type="text" class="modern-input" v-model="nickname" placeholder="Digite seu apelido">
          </div>
          
          <button class="btn-create-room" @click="createRoom" :disabled="!nickname.trim()">
            <i class="fas fa-plus-circle"></i>
            <span>Criar Sala</span>
          </button>
          
          <div v-if="roomUrl" class="room-url">
            <div class="success-message">
              <i class="fas fa-check-circle"></i>
              <span>Sala criada com sucesso!</span>
            </div>
            <p class="share-text">Compartilhe este link com seus amigos:</p>
            <div class="url-container">
              <input type="text" class="url-input" :value="roomUrl" readonly>
              <button class="btn-copy-link" @click="copyUrl" title="Copiar link">
                <i class="fas fa-copy"></i>
                <span>Copiar</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      nickname: '',
      roomUrl: ''
    };
  },
  methods: {
    close() {
      this.$emit('close');
    },
    createRoom() {
      const roomId = Math.random().toString(36).substring(7);
      this.roomUrl = `${window.location.origin}/rooms/${roomId}`;
      this.$emit('room-created', roomId);
    },
    copyUrl() {
      navigator.clipboard.writeText(this.roomUrl);
    }
  }
};
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10000;
  backdrop-filter: blur(5px);
}

.modal-container {
  width: 90%;
  max-width: 500px;
  animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-50px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.modal-content {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  color: white;
  overflow: hidden;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 25px 30px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-content {
  display: flex;
  align-items: center;
  gap: 15px;
}

.header-icon {
  font-size: 2rem;
  background: linear-gradient(135deg, #ff6b6b, #feca57);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.modal-title {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  color: white;
}

.btn-close {
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.6);
  font-size: 1.5rem;
  cursor: pointer;
  padding: 5px;
  border-radius: 50%;
  width: 35px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.btn-close:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
}

.modal-body {
  padding: 30px;
}

.input-section {
  margin-bottom: 25px;
}

.input-label {
  display: block;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
  margin-bottom: 8px;
  font-size: 1rem;
}

.modern-input {
  width: 100%;
  padding: 15px 20px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 1rem;
  outline: none;
  transition: all 0.3s ease;
}

.modern-input::placeholder {
  color: rgba(255, 255, 255, 0.5);
}

.modern-input:focus {
  border-color: #ff6b6b;
  background: rgba(255, 255, 255, 0.1);
  box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.2);
}

.btn-create-room {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 16px 24px;
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
  margin-bottom: 25px;
}

.btn-create-room:hover:not(:disabled) {
  background: linear-gradient(135deg, #ff5252, #d63031);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
}

.btn-create-room:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.btn-create-room i {
  font-size: 1.2rem;
}

.room-url {
  text-align: center;
  animation: fadeInUp 0.5s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.success-message {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 20px;
  padding: 15px;
  background: rgba(76, 175, 80, 0.1);
  border: 1px solid rgba(76, 175, 80, 0.3);
  border-radius: 10px;
  color: #4CAF50;
}

.success-message i {
  font-size: 1.2rem;
}

.share-text {
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 15px;
  font-size: 1rem;
}

.url-container {
  display: flex;
  gap: 10px;
  align-items: center;
}

.url-input {
  flex: 1;
  padding: 12px 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.05);
  color: white;
  font-size: 0.9rem;
  outline: none;
}

.url-input:focus {
  border-color: #ff6b6b;
  box-shadow: 0 0 0 2px rgba(255, 107, 107, 0.2);
}

.btn-copy-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: linear-gradient(135deg, #74b9ff, #0984e3);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(116, 185, 255, 0.3);
}

.btn-copy-link:hover {
  background: linear-gradient(135deg, #0984e3, #74b9ff);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(116, 185, 255, 0.4);
}

.btn-copy-link i {
  font-size: 1rem;
}

/* Responsividade */
@media (max-width: 768px) {
  .modal-container {
    width: 95%;
    margin: 20px;
  }
  
  .modal-header, .modal-body {
    padding: 20px;
  }
  
  .url-container {
    flex-direction: column;
  }
  
  .btn-copy-link {
    width: 100%;
    justify-content: center;
  }
}
</style>
