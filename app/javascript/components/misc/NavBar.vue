<template>
  <b-navbar toggleable="md" type="dark" variant="dark">
    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand to="/">TURD MATE</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">
      <b-navbar-nav>
        <b-nav-item v-if="$store.state.username" to="/DashBoard">Dashboard</b-nav-item>
        <b-nav-item v-if="$store.state.username" to="/ApartmentMate">Apartment Mates</b-nav-item>
        <b-nav-item v-if="$store.state.username" to="/Documents">Documents</b-nav-item>
        <b-nav-item v-if="$store.state.username" to="/Items">Items</b-nav-item>
        <b-nav-item v-if="$store.state.username" to="/Expenses">Expenses</b-nav-item>
        <b-nav-item v-if="$store.state.username" to="/Notifications">Notifications</b-nav-item>

      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav v-if="$store.state.username" class="ml-auto">
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
      this.$store.commit("setUsername", undefined, false);
      this.$store.commit("setPassword", undefined, false);
      this.$store.commit("setDisplayName", undefined, false);
      this.$store.commit("setPhoneNumber", undefined, false);
      this.$store.commit("setApartmentId", undefined, false);

      this.$cookie.delete('username');
      this.$cookie.delete('password');
      this.$cookie.delete('displayName');
      this.$cookie.delete('phoneNumber');
      this.$cookie.delete('apartmentId');

      this.$router.push({ path: "SplashScreen" });
    }
  }
};
</script>

<style scoped>
</style>
