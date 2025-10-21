<template>
  <div>
    <h2>Participants</h2>
    <ul>
      <li v-for="participant in participants" :key="participant.id">
        {{ participant.name }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      participants: []
    };
  }
};
</script>
