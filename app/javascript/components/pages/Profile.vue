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

					<b-row class="my-1">
						<b-col sm="3">
							<label>Email:</label>
						</b-col>
						<b-col sm="8">
							<b-form-input v-model="text" placeholder=""></b-form-input>
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
                                    <b-button v-b-modal="'modal-1'" variant="danger">Delete Account</b-button>
                                </b-col>

                                <b-modal id="modal-1" hide-footer title="Delete Account">
                                    <p><b>Are you SURE you wish to delete your account?</b></p>
                                    <p><i>Note: This action can not be undone.</i></p>
                                    <b-button class="mt-2" variant="info">No, I am not sure.</b-button>
                                    <b-button class="mt-2" variant="danger">Yes, I am sure.</b-button>
                                </b-modal>
							</b-row>
						</div>
                    </div>
                </div>
			</template>
		</b-jumbotron>
	</div>
</template>

<script>
    export default {
        name: "Profile"
    }
</script>
