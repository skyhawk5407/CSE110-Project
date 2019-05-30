import Vue from 'vue'
import Vuex from "vuex";

Vue.use(Vuex);

/**
 * Handles global state.
 */
export default new Vuex.Store({
  state: {
      username: undefined,
      password: undefined,
      displayName: undefined,
      phonenumber: undefined,
      apartmentId: undefined,
  },
  mutations: {
    setUsername (state, username) {
        state.username = username;
    },
    setPassword (state, password) {
        state.password = password;
    },
    setDisplayName (state, displayName) {
        state.displayName = displayName;
    },
    setPhoneNumber (state, phonenumber) {
        state.phonenumber = phonenumber;
    },
    setApartmentId (state, apartmentId) {
        state.apartmentId = apartmentId;
    }
  }
});