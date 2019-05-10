
<template>
  <div>
    <!-- KEEP THIS CODE BELOW -->
    <button v-on:click="showApartment">Click Apartment Here</button>
    <Apartment v-if="hide"/>
    <!-- KEEP THIS CODE ABOVE -->

    <b-carousel
      id="carousel-fade"
      v-model="slide"
      style="text-shadow: 0px 0px 2px #000"
      :interval="4000"
      fade
      controls
      indicators
      img-width="1024"
      img-height="480"
    >
      <!-- Slides with custom text -->
      <b-carousel-slide img-src="/DOM.JPG" class-width="" img-height="">
        <h1>Hello world!</h1>
      </b-carousel-slide>
      <b-carousel-slide img-src="/EX.JPG">
        <h1>Hello world!</h1>
      </b-carousel-slide>
    </b-carousel>
  </div>
</template>

<style>
</style>

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
    };
  },
  methods: {
    showApartment: function() {
      this.hide = !this.hide;
    }
  }
};
</script>
