<template>
	<div>
		<b-jumbotron>
			<template slot="header">
				Profile
			</template>
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

                    <div style="margin-top: 20px">
                        <b-row class="my-1">
                            <b-col offset="3">
                                <b-button>Update Preferences</b-button>
                            </b-col>
                        </b-row>
                    </div>

					<div style="margin-top: 20px">
						<b-row class="my-1">
							<b-col sm="3">
								<label>Old Password:</label>
							</b-col>
							<b-col sm="8">
								<b-form-input v-model="text" placeholder=""></b-form-input>
							</b-col>
						</b-row>
						<b-row class="my-1">
							<b-col sm="3">
								<label>New Password:</label>
							</b-col>
							<b-col sm="8">
								<b-form-input v-model="text" placeholder=""></b-form-input>
							</b-col>
						</b-row>

						<div style="margin-top: 20px">
							<b-row class="my-1">
								<b-col offset="3">
									<b-button>Change Password</b-button>
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
				//account_phone_number: this.$store.state.phonenumber,
                delete_alert_message: undefined,
                show_delete_alert: false
            }
		},
		methods: {
			async delete_account() {
                try {
                    let response = api.delete_account.delete(this.$store.state.username,
                        this.$store.state.password);

                    this.$store.commit('setUsername', this.login_email_text);
                    this.$store.commit('setPassword', this.login_password_text);

                    this.delete_alert_message = response.data;
                    this.show_delete_alert = true;

                } catch(err) {
                    this.delete_alert_message = err.response.data;
                    this.show_delete_alert = true;
                }
                this.$bvModal.hide('modal_delete_account');
			}
		}
    }
</script>
