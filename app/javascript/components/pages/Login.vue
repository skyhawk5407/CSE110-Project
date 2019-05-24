<template>
  <div>
    <b-jumbotron>
      <template slot="lead">
		<div>
			<b-row class="my-1">
				<b-col sm="6">
					<b-form-input v-model="login_email_text" placeholder="Email"></b-form-input>
				</b-col>
			</b-row>
			<b-row class="my-2">
				<b-col sm="6">
					<b-form-input v-model="login_password_text" type="password" placeholder="Password"></b-form-input>
				</b-col>
			</b-row>
            <b-alert variant="danger" :show="show_login_fail">{{ isSuccess }}</b-alert>
		</div>
		<div style="margin-top: 20px">
			<b-form-checkbox v-model="remember_me">Remember me</b-form-checkbox>
		</div>
		<div style="margin-top: 20px">
			<b-button class="btn" variant="success" @click="login">Login</b-button>
			<b-button class="btn" to="AccountCreation" variant="info">Create Account</b-button>
            <b-button class="btn" v-b-modal="'modal-1'" variant="info">Forgot Password</b-button>

            <b-modal id="modal-1" title="Account Recovery">
                <label>E-mail:</label>
                <b-form-input placeholder=""></b-form-input>
            </b-modal>
		</div>
      </template>
    </b-jumbotron>
  </div>
</template>

<script>
    import api from '../../api.js';

    export default {
        name: "Login",
        data() {
            return {
                login_email_text: undefined,
                login_password_text: undefined,
                isSuccess: undefined,
                show_login_fail: false,
                remember_me: false,
            }
        },
        methods: {
            async login() {
                try {
                    let response = await api.login.get(this.login_email_text,
                        this.login_password_text);
                    // TODO: Login permanence if remember me is checked
                    if (this.remember_me) {

                    }

                    this.$store.commit('setUsername', this.login_email_text);
                    this.$store.commit('setPassword', this.login_password_text);
                    this.$store.commit('setDisplayName', response.data.display_name);

                    if (response.data.apartment_id == null) {
                        this.$router.push({path: 'Dashboardi'});
                    } else {
                        this.$router.push({path: 'Dashboard'});
                    }

                    this.show_login_fail = false;
                } catch(err) {
                    this.isSuccess = err.response.data;
                    this.show_login_fail = true;
                }
            }
        }
    }
</script>

<style scoped>
    .btn {
        border-radius: 5px;
    }
</style>
