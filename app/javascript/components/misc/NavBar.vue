<template>
  <b-navbar toggleable="md" type="dark" variant="dark">

    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand to="/">TURD MATE</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">
      <!-- add conditional ghere -->
      <b-navbar-nav >
        <b-nav-item v-if="$store.state.username" to="/AccountSettings">Account Settings</b-nav-item>
        <b-nav-item  v-if="$store.state.username" to="/Dashboard">Dashboard</b-nav-item>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown text="Options" right>
          <b-dropdown-item to="/AccountSettings">Account Settings</b-dropdown-item>
          <b-dropdown-item v-b-modal="'modal-logout'">Logout</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>

      <b-modal id="modal-logout" title="Logout Confirmation" @ok="logout">
        <p>Are you sure you want to logout?</p>
      </b-modal>

    </b-collapse>
  </b-navbar>
</template>

<script>
  export default {
    name: "NavBar",
      methods: {
        logout() {
            this.$router.push({path: 'Login'});
        }
      }
  }
</script>

<style scoped>

</style>