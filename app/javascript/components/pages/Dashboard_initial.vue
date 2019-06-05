<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Getting Started
      </template>
      <template slot="lead">
        <div style="margin-top: 50px">

          <b-row class="p-3 my-1" align-h="center">
            <b-button v-b-modal="'modal-create-apartment'" class="btn btn-info btn-lg">Create Apartment</b-button>
          </b-row>

          <b-modal id="modal-create-apartment" ref="createModal" title="Create Apartment" ok-title="Create Apartment"
                   @ok='createApartment' cancel-title="Back">
            <label>Apartment Name:</label>
            <b-form-input v-model="apartment_name_text" placeholder=""></b-form-input>

            <label>Apartment Address:</label>
            <b-form-input v-model="apartment_address_text" placeholder=""></b-form-input>
            <b-alert class="my-3" variant="danger" :show="createError">{{createError}}</b-alert>
          </b-modal>

          <b-row class="my-1" align-h="center">
            <b-button v-b-modal="'modal-join-apartment'" class="btn btn-success btn-lg">Join Apartment</b-button>
          </b-row>
          <b-modal id="modal-join-apartment" ref="joinModal" title="Join Apartment" ok-title="Join" @ok='joinApartment'
                   cancel-title="Back">
            <label>Enter Secret Code:</label>
            <b-form-input v-model="apartment_code_text" placeholder=""></b-form-input>
            <b-alert class="my-3" variant="danger" :show="joinError">{{joinError}}</b-alert>
          </b-modal>
        </div>
      </template>
    </b-jumbotron>
  </div>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "One",
    data() {
      return {
        apartment_name_text: undefined,
        apartment_address_text: undefined,
        createError: undefined,
        joinError: undefined,
      }
    },
    methods: {
      joinedApartment() {
        // TODO get apartment id
        this.$store.commit('setApartmentId', true);

        if (this.$cookie.get("isPermanence")) {
          this.$cookie.set('apartmentId', true, 30);
        }
        this.$router.push({path: 'Dashboard'});
      },
      async createApartment(e) {
        e.preventDefault();
        try {
          let response = await api.apartment.post(this.apartment_name_text,
              this.apartment_address_text, this.$store.state.username, this.$store.state.password);
          this.$refs.createModal.hide();
          this.joinedApartment();
          this.createError = undefined;
        } catch (err) {
          if (err.response) {
            this.createError = err.response.data.errors[0];
          }
        }
      },
      async joinApartment(e) {
        e.preventDefault();
        try {
          let response = await api.join.post(this.apartment_code_text, this.$store.state.username, this.$store.state.password);
          this.$refs.joinModal.hide();
          this.joinedApartment();
          this.joinError = undefined;
        } catch (err) {
          if (err.response) {
            this.joinError = err.response.data.errors[0];
          }
        }
      }
    }
  }
</script>

<style scoped>
  .btn {
    border-radius: 5px;
    width: 400px;
    height: 100px;
  }
</style>
