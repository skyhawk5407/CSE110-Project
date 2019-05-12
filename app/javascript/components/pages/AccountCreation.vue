<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Create an Account
      </template>
      <template slot="lead">
		<div style="margin-top: 50px">
			<b-row class="my-1">
				<b-col sm="3">
					<label>First Name:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="text" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Middle Name:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="text" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Last Name:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="text" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			
			<div style="margin-top: 50px">
				<b-row class="my-1">
					<b-col sm="3">
						<label>Email:</label>
					</b-col>
					<b-col sm="8">
						<b-form-input v-model="text" placeholder=""></b-form-input>
					</b-col>
				</b-row>
			</div>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Password:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="text" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Confirm Password:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="text" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			
			<div style="margin-top: 20px">
				<b-row class="my-1">
					<b-col offset="3">
						<b-button>Create an Account</b-button>
					</b-col>
				</b-row>
			</div>
		</div>
      </template>
    </b-jumbotron>
  </div>
</template>

<script>
  export default {
    name: "AccountCreation"
  }
</script>
