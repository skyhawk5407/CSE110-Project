<template>
<div>
	<b-jumbotron>
	<template slot="lead">
		<div style="margin-top: 50px">
			<b-row class="my-1">
				<b-col sm="3">
					<label>Display Name*:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="register_display_name" placeholder=""></b-form-input>
				</b-col>
			</b-row>

			<b-row class="my-1">
				<b-col sm="3">
					<label>Phone Number:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="register_phone_number" type="tel" placeholder=""></b-form-input>
				</b-col>
			</b-row>

			<div style="margin-top: 50px">
				<b-row class="my-1">
					<b-col sm="3">
						<label>Email*:</label>
					</b-col>
					<b-col sm="8">
						<b-form-input v-model="register_email" placeholder=""></b-form-input>
					</b-col>
				</b-row>
			</div>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Password*:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="register_password" type="password" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-1">
				<b-col sm="3">
					<label>Confirm Password*:</label>
				</b-col>
				<b-col sm="8">
					<b-form-input v-model="register_password_check" type="password" placeholder=""></b-form-input>
				</b-col>
			</b-row>
			<h6><i>* is required</i></h6>
			<b-alert variant="danger" :show="show_register_fail">{{ isSuccess }}</b-alert>
			
			<div style="margin-top: 20px">
				<b-row class="my-1">
					<b-col offset="3">
						<b-button variant="info" @click="register">Register</b-button>
					</b-col>
				</b-row>
			</div>
		</div>
	</template>
	</b-jumbotron>
</div>
</template>

<script>
	import api from '../../api.js';

	export default {
	name: "AccountCreation",
	data() {
		return {
			register_email: "",
			register_display_name: "",
			register_password: "",
			register_password_check: "",
			register_phone_number: "",
			isSuccess: undefined,
			show_register_fail: false,
			remember_me: false,
		}
	},
	methods: {
		async register() {
			try {
				if (this.register_password !== this.register_password_check) {
					this.isSuccess = "Passwords do not match.";
					this.show_register_fail = true;
					return;
				}

				await api.register.post(this.register_email,
					this.register_password, this.register_display_name,
					this.register_phone_number);

				this.$store.commit('setUsername', this.register_email);
				this.$store.commit('setPassword', this.register_password);
				this.$store.commit('setDisplayName', this.register_display_name);

				this.$router.push({path: 'Dashboardi'});

				this.show_register_fail = false;
			} catch(err) {
				if(typeof err.response.data === "string") {
					this.isSuccess = err.response.data;
				} else {
					this.isSuccess = err.response.data.errors[0];
				}
				this.show_register_fail = true;
			}
		}
	}
}
</script>
