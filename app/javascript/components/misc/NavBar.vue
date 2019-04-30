<template>
  <b-navbar toggleable="md" type="dark" variant="dark">

    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand>Text</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">

      <b-navbar-nav>
        <b-nav-item to="/one">One</b-nav-item>
        <b-nav-item to="/two">Two</b-nav-item>
      </b-navbar-nav>

      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown text="Dropdown" right>
          <b-dropdown-item v-b-modal.modal-one>Show Modal 1</b-dropdown-item>
          <b-dropdown-item v-b-modal.modal-two>Show Modal 2</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>

      <!-- Modal Component -->
      <b-modal id="modal-one" centered title="Bootstrap-Vue">
        <p class="my-4">Vertically centered modal 1!</p>
      </b-modal>

      <b-modal id="modal-two" centered title="Bootstrap-Vue">
        <p class="my-4">Vertically centered modal 2!</p>
      </b-modal>

    </b-collapse>
  </b-navbar>
</template>

<script>
  export default {
    name: "NavBar",
  }
</script>

<style scoped>

</style>