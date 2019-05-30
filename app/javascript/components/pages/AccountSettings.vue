<template>
	<div>
		<b-jumbotron>
			<template slot="lead">
				<div style="margin-top: 20px">
					<b-row class="my-1">
						<b-col sm="3">
							<label>Email:</label>
						</b-col>
						<b-col sm="8">
							<b-form-input :placeholder="$store.state.username" :disabled="true"></b-form-input>
						</b-col>
					</b-row>
					<b-row class="my-1">
						<b-col sm="3">
							<label>Display Name:</label>
						</b-col>
						<b-col sm="8">
							<b-form-input v-model="account_display_name" :placeholder="$store.state.displayName"></b-form-input>
						</b-col>
					</b-row>
					<b-row class="my-1">
						<b-col sm="3">
							<label>Phone Number:</label>
						</b-col>
						<b-col sm="8">
							<b-form-input v-model="account_phone_number" :placeholder="$store.state.phonenumber"></b-form-input>
						</b-col>
					</b-row>
					<b-alert variant="success" :show="show_good_account_message">{{ account_good_alert_message }}</b-alert>
					<b-alert variant="danger" :show="show_account_alert">{{ account_alert_message }}</b-alert>
                    <div style="margin-top: 20px">
                        <b-row class="my-1">
                            <b-col offset="3">
                                <b-button @click="update_account">Update Preferences</b-button>
                            </b-col>
                        </b-row>
                    </div>

					<div style="margin-top: 20px">
						<b-row class="my-1">
							<b-col sm="3">
								<label>Old Password:</label>
							</b-col>
							<b-col sm="8">
								<b-form-input v-model="account_old_password" type="password" placeholder=""></b-form-input>
							</b-col>
						</b-row>
						<b-row class="my-1">
							<b-col sm="3">
								<label>New Password:</label>
							</b-col>
							<b-col sm="8">
								<b-form-input v-model="account_new_password" type="password" placeholder=""></b-form-input>
							</b-col>
						</b-row>
						<b-row class="my-1">
							<b-col sm="3">
								<label>Confirm Password:</label>
							</b-col>
							<b-col sm="8">
								<b-form-input v-model="account_confirm_password" type="password" placeholder=""></b-form-input>
							</b-col>
						</b-row>


						<div style="margin-top: 20px">
							<b-row class="my-1">
								<b-col offset="3">
									<b-button @click="update_password">Change Password</b-button>
								</b-col>

                                <b-col offset="4">
                                    <b-button v-b-modal="'modal_delete_account'" variant="danger">Delete Account</b-button>
                                </b-col>

                                <b-modal id="modal_delete_account" hide-footer title="Delete Account">
                                    <p><b>Are you SURE you wish to delete your account?</b></p>
                                    <p><i>Note: This action can not be undone.</i></p>
                                    <b-button class="mt-2"
                                              variant="info"
                                              @click="$bvModal.hide('modal_delete_account')">
                                        No, I am not sure.
                                    </b-button>
                                    <b-button class="mt-2" variant="danger" @click="delete_account">Yes, I am sure.</b-button>
                                </b-modal>
							</b-row>
						</div>
                        <b-alert variant="danger" :show="show_delete_alert">{{ delete_alert_message }}</b-alert>
						<b-alert variant="success" :show="show_good_password_alert">{{ account_good_password_message }}</b-alert>
                    </div>
                </div>
			</template>
		</b-jumbotron>
	</div>
</template>

<script>
    import api from '../../api.js';

    export default {
        name: "AccountSettings",
		data() {
            return {
                account_display_name: this.$store.state.displayName,
				account_phone_number: this.$store.state.phonenumber,
				account_old_password: "",
				account_new_password: "",
				account_confirm_password: "",
				account_good_alert_message: undefined,
				account_good_password_message: undefined,
				show_good_password_alert: undefined,
				show_good_account_message: undefined,
				account_alert_message: undefined,
				show_account_alert: false,
                delete_alert_message: undefined,
                show_delete_alert: false
            }
		},
		methods: {
			async update_account() {
				try {
					let response = await api.users.update.update_account(
						this.$store.state.username, this.$store.state.password,
						this.account_display_name, this.account_phone_number);

					let is_using_cookies = this.$cookie.get("isPermanence");
					this.$store.commit('setDisplayName', this.account_display_name);
					this.$store.commit('setPhoneNumber', this.account_phone_number);
					if(is_using_cookies) {
						this.$cookie.set('displayName', this.account_display_name, 30);
						this.$cookie.set('phoneNumber', this.account_phone_number, 30);
					}
					
					this.account_good_alert_message = response.data;
					this.show_good_account_message = true;
					this.show_account_alert = false;
				} catch (err) {
					if(typeof err.response.data === "string") {
						this.account_alert_message = err.response.data;
					} else {
						this.account_alert_message = err.response.data.errors[0];
					}
					this.show_account_alert = true;
					this.show_good_account_message = false;
				}
			},

			async update_password() {
				try {
					if (this.$store.state.password != this.account_old_password) {
						this.delete_alert_message = "Old password incorrect";
						this.show_delete_alert = true;
						return;
					}

					if (this.account_new_password != this.account_confirm_password) {
						this.delete_alert_message = "Passwords do not match";
						this.show_delete_alert = true;
						return;
					}

					if (this.account_confirm_password.length < 5) {
						this.delete_alert_message = "Password is too short (minimum is 5 characters)";
						this.show_delete_alert = true;
						return;
					}

					let response = await api.users.update.update_password(
						this.$store.state.username, this.$store.state.password,
						this.account_confirm_password);

					let is_using_cookies = this.$cookie.get("isPermanence");
					this.$store.commit("setPassword", this.account_confirm_password);
					if (is_using_cookies) {
						this.$cookie.set("password", this.account_confirm_password)
					}

					this.account_good_password_message = response.data;
					this.show_good_password_alert = true;
					this.show_delete_alert = false;
				} catch(err) {
					if(typeof err.response.data === "string") {
						this.delete_alert_message = err.response.data;
					} else {
						this.delete_alert_message = err.response.data.errors[0];
					}
					this.show_delete_alert = true;
					this.show_good_password_alert = false;
				}
			},

			async delete_account() {
                try {			
                    let response = await api.users.delete_account.delete(this.$store.state.username,
                        this.$store.state.password);

                    this.$store.commit('setUsername', undefined);
					this.$store.commit('setPassword', undefined);
					this.$store.commit('setDisplayName', undefined);
					this.$store.commit('setPhoneNumber', undefined);
					this.$store.commit('setApartmentId', undefined);
			
					this.$cookie.delete('username');
					this.$cookie.delete('password');
					this.$cookie.delete('displayName');
					this.$cookie.delete('phoneNumber');
					this.$cookie.delete('apartmentId');
					
					this.$router.push({path: 'SplashScreen'});
                } catch(err) {
                    this.delete_alert_message = err.response.data;
                    this.show_delete_alert = true;
                }
                this.$bvModal.hide('modal_delete_account');
			}
		}
    }
</script>
