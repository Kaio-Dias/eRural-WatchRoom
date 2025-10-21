<template>
  <div>
    <input type="text" v-model="youtubeUrl" placeholder="Enter YouTube URL">
    <button @click="submitUrl">Submit</button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      youtubeUrl: ''
    };
  },
  methods: {
    submitUrl() {
      // Implementation for submitting the YouTube URL
    }
  }
};
</script>
