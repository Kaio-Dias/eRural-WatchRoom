<template>
  <div class="player-container">
    <div id="player"></div>
  </div>
</template>

<script>
export default {
  props: {
    videoId: {
      type: String,
      required: true
    }
  },
  mounted() {
    if (!window.YT) {
      const tag = document.createElement('script');
      tag.src = "https://www.youtube.com/iframe_api";
      const firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      window.onYouTubeIframeAPIReady = () => {
        this.createPlayer();
      };
    } else {
      this.createPlayer();
    }
  },
  methods: {
    createPlayer() {
      this.player = new window.YT.Player('player', {
        height: '100%',
        width: '100%',
        videoId: this.videoId,
        playerVars: {
          'playsinline': 1
        },
        events: {
          onStateChange: (event) => {
            // 1 = playing, 2 = paused
            if (event.data === window.YT.PlayerState.PLAYING) {
              this.$emit('play', { currentTime: this.getCurrentTime() });
            }
            if (event.data === window.YT.PlayerState.PAUSED) {
              this.$emit('pause', { currentTime: this.getCurrentTime() });
            }
          }
        }
      });
    },
    load(id, startSeconds = 0) {
      if (this.player && id) {
        this.player.loadVideoById({ videoId: id, startSeconds });
      }
    },
    cue(id, startSeconds = 0) {
      if (this.player && id) {
        this.player.cueVideoById({ videoId: id, startSeconds });
      }
    },
    play() {
      if (this.player) this.player.playVideo();
    },
    pause() {
      if (this.player) this.player.pauseVideo();
    },
    seekTo(seconds) {
      if (this.player && typeof seconds === 'number') {
        this.player.seekTo(seconds, true);
      }
    },
    getCurrentTime() {
      return this.player ? this.player.getCurrentTime() : 0;
    }
  },
  watch: {
    videoId(newVal) {
      if (this.player) {
        this.player.loadVideoById(newVal);
      }
    }
  }
};
</script>

<style scoped>
.player-container {
  position: relative;
  width: 100%;
  height: 100%;
  max-width: 1280px;
  max-height: 720px;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
}

#player {
  width: 100%;
  height: 100%;
  border: none;
  border-radius: 8px;
  object-fit: cover;
}
</style>