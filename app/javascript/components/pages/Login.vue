<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Login
      </template>
      <template slot="lead">
		<div style="margin-top: 50px">
			<b-row class="my-1">
				<b-col sm="6">
					<b-form-input v-model="text" placeholder="Email"></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-2">
				<b-col sm="6">
					<b-form-input v-model="text" placeholder="Password"></b-form-input>
				</b-col>
			</b-row>
		</div>
		<div style="margin-top: 20px">
			<b-form-checkbox>Remember me</b-form-checkbox>
			
			<b-button class="btn" v-b-modal="'modal-1'" variant="info">Forgot Your Password?</b-button>
			
			<b-modal id="modal-1" title="Account Recovery">
					<label>E-mail:</label>
					<b-form-input v-model="text" placeholder=""></b-form-input>
			</b-modal>
		</div>
		<div style="margin-top: 20px">
			<b-button class="btn" href="Dashboardi" variant="success">Login</b-button>
			<b-button class="btn" href="AccountCreation" variant="info">Create an Account</b-button>
		</div>
      </template>
    </b-jumbotron>
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
