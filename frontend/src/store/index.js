import { createStore } from 'vuex';

export default createStore({
  state: {
    room: null,
    participants: [],
    messages: [],
    video: null
  },
  mutations: {
    setRoom(state, room) {
      state.room = room;
    },
    setParticipants(state, participants) {
      state.participants = participants;
    },
    setMessages(state, messages) {
      state.messages = messages;
    },
    setVideo(state, video) {
      state.video = video;
    }
  },
  actions: {
    createRoom({ commit }, nickname) {
      // Implementation for creating a room
    },
    joinRoom({ commit }, roomUrl) {
      // Implementation for joining a room
    },
    sendMessage({ commit }, message) {
      // Implementation for sending a message
    },
    setVideoUrl({ commit }, videoUrl) {
      // Implementation for setting the video URL
    }
  },
  getters: {
    room(state) {
      return state.room;
    },
    participants(state) {
      return state.participants;
    },
    messages(state) {
      return state.messages;
    },
    video(state) {
      return state.video;
    }
  }
});
