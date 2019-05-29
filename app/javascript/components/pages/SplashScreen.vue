<template>
  <div>
    <b-img center :src="require('../../../../public/CSE110Logo.png')" fluid></b-img>
    <div v-if="!$store.state.username">
      <b-row align-h="center">
        <b-button center class="m-1 btn" size="lg" to="Login" variant="success">Login</b-button>
        <b-button center class="m-1 btn" size="lg" to="AccountCreation" variant="info">Create Account</b-button>
      </b-row>
    </div>
    <div v-else>
      <b-row align-h="center">
        <b-button center class="m-1 btn" size="lg" to="Dashboard" variant="success">Dashboard</b-button>
      </b-row>
    </div>
  </div>
</template>

<script>
  export default {
    name: "Login"
  }
</script>

<style scoped>
  .btn {
    border-radius: 5px;
  }
</style>
