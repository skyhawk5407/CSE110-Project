<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Getting Started
      </template>
      <template slot="lead">
		<div style="margin-top: 50px">

			<b-row class="p-3 my-1" align-h="center">
				<b-button v-b-modal="'modal-1'" class="btn btn-info btn-lg">Create Apartment</b-button>
			</b-row>
            <b-modal id="modal-1" title="Create Apartment">
                <label>Apartment Name:</label>
                <b-form-input v-model="text" placeholder=""></b-form-input>
            </b-modal>

			<b-row class="my-1" align-h="center">
				<b-button v-b-modal="'modal-2'" class="btn btn-success btn-lg">Join Apartment</b-button>
			</b-row>
            <b-modal id="modal-2" title="Join Apartment">
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
