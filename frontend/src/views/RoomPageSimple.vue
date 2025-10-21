<template>
  <div class="room-simple">
    <h1>Sala: {{ $route.params.slug }}</h1>
    <p>Esta é uma versão simplificada da página da sala.</p>
    <button @click="showModal = true">Mostrar Participantes</button>
    
    <div v-if="showModal" class="modal" @click="showModal = false">
      <div class="modal-content" @click.stop>
        <h3>Participantes</h3>
        <button @click="showModal = false">Fechar</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showModal: false
    };
  }
};
</script>

<style scoped>
.room-simple {
  padding: 20px;
  background-color: #181818;
  color: white;
  min-height: 100vh;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background-color: #2a2a2a;
  padding: 20px;
  border-radius: 8px;
  color: white;
}
</style>
