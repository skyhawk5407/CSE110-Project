<template>
  <div id="app">
    <nav-bar></nav-bar>

    <div class="my-5 mx-auto" style="width: 80%; height: 100%;">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import NavBar from "./components/misc/NavBar";
export default {
  name: "App",
  components: { NavBar },
};
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

#app {
  min-height: 100%;
  background-color: transparent;
}

</style>
