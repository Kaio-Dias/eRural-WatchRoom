<template>
  <div class="home">
    <div class="background-gradient"></div>
    <div class="container">
      <div class="row justify-content-center align-items-center vh-100">
        <div class="col-lg-8 col-xl-6">
          <div class="welcome-card">
            <div class="card-header">
              <div class="logo-section">
                <div class="logo-icon">🎬</div>
                <h1 class="app-title">eRural WatchRoom</h1>
                <p class="app-subtitle">Assista vídeos em sincronia com seus amigos</p>
              </div>
            </div>
            <div class="card-body">
              <div class="create-section">
                <button class="btn-create-room" @click="showModal = true">
                  <i class="fas fa-plus-circle"></i>
                  <span>Criar Nova Sala</span>
                </button>
                <p class="no-login-text">✨ Não é necessário fazer login</p>
              </div>
              
              <div class="features-section">
                <h3>Recursos Disponíveis</h3>
                <div class="features-grid">
                  <div class="feature-item">
                    <i class="fas fa-sync-alt"></i>
                    <span>Sincronização em tempo real</span>
                  </div>
                  <div class="feature-item">
                    <i class="fas fa-comments"></i>
                    <span>Chat interativo</span>
                  </div>
                  <div class="feature-item">
                    <i class="fas fa-smile"></i>
                    <span>Emojis flutuantes</span>
                  </div>
                  <div class="feature-item">
                    <i class="fas fa-users"></i>
                    <span>Múltiplos participantes</span>
                  </div>
                </div>
              </div>
              
              <div class="supported-platforms">
                <h4>Plataforma Suportada</h4>
                <div class="platform-icons">
                  <div class="platform-item youtube-platform">
                    <i class="fab fa-youtube"></i>
                    <span>YouTube</span>
                    <p class="platform-desc">Cole qualquer link do YouTube para assistir junto!</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <ShareModal v-if="showModal" @close="showModal = false" @room-created="joinRoom" />
  </div>
</template>

<script>
import ShareModal from '../components/ShareModal.vue';

export default {
  components: {
    ShareModal
  },
  data() {
    return {
      showModal: false
    };
  },
  methods: {
    joinRoom(roomId) {
      this.$router.push({ name: 'room', params: { slug: roomId } });
    }
  }
};
</script>

<style scoped>
.home {
  position: relative;
  overflow: hidden;
  min-height: 100vh;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
}

.background-gradient {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
  z-index: -1;
}

@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

.welcome-card {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.welcome-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
}

.card-header {
  padding: 40px 40px 20px;
  text-align: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.logo-icon {
  font-size: 4rem;
  background: linear-gradient(135deg, #ff6b6b, #feca57);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-10px); }
  60% { transform: translateY(-5px); }
}

.app-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: white;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
  background: linear-gradient(135deg, #ff6b6b, #feca57, #48dbfb);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.app-subtitle {
  font-size: 1.1rem;
  color: rgba(255, 255, 255, 0.8);
  margin: 0;
  font-weight: 300;
}

.card-body {
  padding: 30px 40px 40px;
}

.create-section {
  text-align: center;
  margin-bottom: 40px;
}

.btn-create-room {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 16px 32px;
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
}

.btn-create-room:hover {
  background: linear-gradient(135deg, #ff5252, #d63031);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255, 107, 107, 0.4);
}

.btn-create-room i {
  font-size: 1.2rem;
}

.no-login-text {
  margin-top: 15px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.9rem;
  font-style: italic;
}

.features-section {
  margin-bottom: 30px;
}

.features-section h3 {
  color: white;
  font-size: 1.3rem;
  margin-bottom: 20px;
  text-align: center;
  font-weight: 600;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 15px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 10px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.feature-item:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateX(5px);
}

.feature-item i {
  font-size: 1.2rem;
  color: #feca57;
  width: 20px;
  text-align: center;
}

.feature-item span {
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
}

.supported-platforms {
  text-align: center;
}

.supported-platforms h4 {
  color: white;
  font-size: 1.1rem;
  margin-bottom: 15px;
  font-weight: 600;
}

.platform-icons {
  display: flex;
  justify-content: center;
  gap: 25px;
  flex-wrap: wrap;
}

.platform-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 20px;
  border-radius: 15px;
  transition: all 0.3s ease;
  cursor: pointer;
  text-align: center;
}

.youtube-platform {
  background: linear-gradient(135deg, rgba(255, 0, 0, 0.1), rgba(255, 0, 0, 0.05));
  border: 2px solid rgba(255, 0, 0, 0.2);
  box-shadow: 0 4px 15px rgba(255, 0, 0, 0.1);
}

.platform-item:hover {
  background: rgba(255, 255, 255, 0.05);
  transform: translateY(-5px);
}

.youtube-platform:hover {
  background: linear-gradient(135deg, rgba(255, 0, 0, 0.15), rgba(255, 0, 0, 0.08));
  border-color: rgba(255, 0, 0, 0.3);
  transform: translateY(-5px) scale(1.02);
}

.platform-item i {
  font-size: 3rem;
  color: #ff0000;
  transition: all 0.3s ease;
  margin-bottom: 5px;
}

.youtube-platform i {
  color: #ff0000;
  text-shadow: 0 0 10px rgba(255, 0, 0, 0.3);
}

.platform-item:hover i {
  transform: scale(1.1);
}

.youtube-platform:hover i {
  color: #ff3333;
  text-shadow: 0 0 15px rgba(255, 0, 0, 0.5);
  transform: scale(1.15);
}

.platform-item span {
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 5px;
}

.platform-desc {
  color: rgba(255, 255, 255, 0.7);
  font-size: 0.85rem;
  margin: 0;
  max-width: 200px;
  line-height: 1.3;
}

/* Responsividade */
@media (max-width: 768px) {
  .welcome-card {
    margin: 20px;
  }
  
  .card-header, .card-body {
    padding: 30px 25px;
  }
  
  .app-title {
    font-size: 2rem;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
  
  .platform-icons {
    gap: 15px;
  }
  
  .platform-item i {
    font-size: 1.5rem;
  }
}
</style>