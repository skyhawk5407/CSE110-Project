
<template>
  <div>
    <!-- KEEP THIS CODE BELOW -->
    <button v-on:click="showApartment">Click Apartment Here</button>
    <Apartment v-if="hide"/>
    <!-- KEEP THIS CODE ABOVE -->

    <b-carousel
      id="carousel-fade"
      v-model="slide"
      :interval="4000"
      controls
      indicators
      background="#ababab"
      img-width="550"
      img-height="450"
      style="text-shadow: 1px 1px 2px #333;"
      @sliding-start="onSlideStart"
      @sliding-end="onSlideEnd"
    >
      <!-- Slides with custom text -->
      <b-carousel-slide img-src="/DOM.JPG">
        <h1>Hello world!</h1>
      </b-carousel-slide>
      <b-carousel-slide img-src="/EX.JPG">
        <h1>Hello world!</h1>
      </b-carousel-slide>
    </b-carousel>
  </div>
</template>

<script>
// KEEP ALL HERE
import Apartment from "./ApartmentMate.vue";
export default {
  name: "Dashboard",
  components: {
    Apartment
  },
  data() {
      return {
        hide: false
      }
  },
  methods: {
    showApartment: function() {
      this.hide = !this.hide;
    }
  },
};
</script>
