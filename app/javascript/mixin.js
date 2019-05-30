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
    },
    truncateFileName(files) {
      const MAX_LENGTH = 48;
      let s = files[0].name.substring(0, MAX_LENGTH);
      if (files[0].name.length > MAX_LENGTH) {
        s += '...';
      }
      return s;
    },
    async b64toBlob(b64Data) {
      return `data:application/octet-stream;base64,${b64Data}`;
    }
  }
});