<template>
  <div class="emoji-overlay" aria-hidden="true">
    <transition-group name="float" tag="div">
      <div
        v-for="item in items"
        :key="item.id"
        class="emoji"
        :style="item.style"
      >{{ item.emoji }}</div>
    </transition-group>
  </div>
</template>

<script>
export default {
  data() {
    return { items: [] };
  },
  methods: {
    burst({ emoji, count = 8 }) {
      console.log('EmojiOverlay.burst called with:', { emoji, count });
      const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      const n = prefersReduced ? Math.min(4, count) : Math.min(16, Math.max(8, count));
      console.log(`Creating ${n} emoji instances`);
      
      for (let i = 0; i < n; i++) {
        const id = `${Date.now()}-${Math.random()}`;
        const left = Math.random() * 80 + 10;
        const duration = 1500 + Math.random() * 800;
        const size = 18 + Math.random() * 14;
        const delay = Math.random() * 150;
        this.items.push({
          id,
          emoji,
          style: {
            left: `${left}%`,
            fontSize: `${size}px`,
            animationDuration: `${duration}ms`,
            animationDelay: `${delay}ms`
          }
        });
        setTimeout(() => {
          this.items = this.items.filter(x => x.id !== id);
        }, duration + 300);
      }
      console.log('Emoji items after burst:', this.items.length);
    }
  }
};
</script>

<style scoped>
.emoji-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  overflow: hidden;
  z-index: 9999;
}
.emoji {
  position: absolute;
  bottom: 30%;
  z-index: 10000;
  font-size: 32px;
  user-select: none;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
}
.float-enter-active,
.float-leave-active {
  transition: transform 0.3s ease-out, opacity 0.3s ease-out;
}
@keyframes floatUp {
  0% { 
    transform: translateY(0px) scale(1); 
    opacity: 1; 
  }
  50% {
    transform: translateY(-100px) scale(1.2);
    opacity: 0.8;
  }
  100% { 
    transform: translateY(-300px) scale(0.8); 
    opacity: 0; 
  }
}
.emoji {
  animation-name: floatUp;
  animation-duration: 3000ms;
  animation-timing-function: ease-out;
  animation-fill-mode: forwards;
}
</style>