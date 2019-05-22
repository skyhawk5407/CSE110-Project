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
            <b-modal id="modal-create-apartment" title="Create Apartment" ok-title="Create Apartment" cancel-title="Back">
                <label>Apartment Name:</label>
                <b-form-input v-model="text" placeholder=""></b-form-input>

                <label>Apartment Address:</label>
                <b-form-input v-model="text" placeholder=""></b-form-input>
            </b-modal>

			<b-row class="my-1" align-h="center">
				<b-button v-b-modal="'modal-join-apartment'" class="btn btn-success btn-lg">Join Apartment</b-button>
			</b-row>
            <b-modal id="modal-join-apartment" title="Join Apartment" ok-title="Join" cancel-title="Back">
                <label>Enter Secret Code:</label>
                <b-form-input v-model="text" placeholder=""></b-form-input>
            </b-modal>
		</div>
      </template>
    </b-jumbotron>
  </div>
</template>

<script>
  export default {
      name: "One"
  }
</script>

<style scoped>
    .btn {
        border-radius: 5px;
        width: 400px;
        height: 100px;
    }
</style>
