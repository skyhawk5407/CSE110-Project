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
            <b-modal id="modal-create-apartment" title="Create Apartment" ok-title="Create Apartment" @ok='createApartment' cancel-title="Back">
                <label>Apartment Name:</label>
                <b-form-input v-model="apartment_name_text" placeholder=""></b-form-input>

                <label>Apartment Address:</label>
                <b-form-input v-model="apartment_address_text" placeholder=""></b-form-input>
            </b-modal>

			<b-row class="my-1" align-h="center">
				<b-button v-b-modal="'modal-join-apartment'" class="btn btn-success btn-lg">Join Apartment</b-button>
			</b-row>
            <b-modal id="modal-join-apartment" title="Join Apartment" ok-title="Join" @ok='joinApartment' cancel-title="Back">
                <label>Enter Secret Code:</label>
                <b-form-input v-model="apartment_code_text" placeholder=""></b-form-input>
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
          apartment_address_text: undefined
        }
      },
      methods: {
        async createApartment(){
          try {
            //HARDCODED replace email and password
            let response = await api.apartment.post(this.apartment_name_text,
              this.apartment_address_text, this.$store.state.username, this.$store.state.password);

              this.$router.push({path: 'Dashboard'});
          } catch(err) {
            if(err.response){
              switch (err.response.status) {
                case 400: //User in apartment or bad apartment name/address
                  console.log(err.response.data);
                  break;
                case 401: //User not logged in
                  console.log(err.reponse.data);
                default:
                  console.log('An unknown error occured.');
                  break;

              }
            }
          }
        },
        async joinApartment() {
          try {
            let response = await api.join.post(this.apartment_code_text, this.$store.state.username, this.$store.state.password);
            console.log(response.status);
            this.$router.push({path: 'Dashboard'});

          } catch(err) {
            if(err.response){
              switch (err.response.status) {
                case 400: //User in apartment or bad apartment name/address
                  console.log(err.response.data);
                  break;
                case 401: //User not logged in
                  console.log(err.reponse.data);
                default:
                  console.log('An unknown error occured.');
                  break;

              }
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
