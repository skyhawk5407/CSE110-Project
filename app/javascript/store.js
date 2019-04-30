import Vue from 'vue'
import Vuex from "vuex";

Vue.use(Vuex);

/**
 * Handles global state.
 */
export default new Vuex.Store({
  state: {
    username: undefined
  },
  mutations: {
    setUsername (state, username) {
      state.username = username;
    }
  }
});