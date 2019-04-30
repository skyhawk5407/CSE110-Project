import Vue from 'vue'

/**
 * These methods are global and usable by any component.
 */
Vue.mixin({
  methods: {
    openTab: (url) => {
      window.open(url, '_blank');
    },
    objectLength: (obj) => {
      return Object.keys(obj).length;
    }
  }
});