<template>
    <div>
      <b-jumbotron header-level="4">
        <template slot="header">
          Reset Password
        </template>
        <template slot="lead" v-if="resetTokenInvalid">
          <b-row class="my-1" align-h="center">
              Could not reset password -- token invalid or expired.
          </b-row>
          <b-row class="my-3" align-h="center">
            If you believe this is in error, request a new password reset email.
          </b-row>

          <b-row class="my-1" align-h="center">
            <b-button to="/" class="btn btn-info btn-lg">Return to Home</b-button>
          </b-row>
        </template>
        <template slot="lead" v-else>
          <div style="margin-top: 20px">
            <b-row class="my-1">
              <b-col sm="3">
                <label>Email:</label>
              </b-col>
              <b-col sm="8">
                <b-form-input :placeholder="email" :disabled="true"></b-form-input>
              </b-col>
            </b-row>
            <div style="margin-top: 20px">
              <b-row class="my-1">
                <b-col sm="3">
                  <label>New Password:</label>
                </b-col>
                <b-col sm="8">
                  <b-form-input type="password" v-model="newPassword"></b-form-input>
                </b-col>
              </b-row>
              <b-row class="my-1">
                <b-col sm="3">
                  <label>Confirm Password:</label>
                </b-col>
                <b-col sm="8">
                  <b-form-input type="password" v-model="newPasswordConfirmation"></b-form-input>
                </b-col>
              </b-row>
              <b-alert :show="responseError" variant="danger">{{ responseText }}</b-alert>
              <b-alert class="my-3" :show="successfulReset">
                <p>{{ responseText }}</p>
                <p>Redirecting in {{ redirectSecs }} seconds...</p>
                <b-progress
                    variant="warning"
                    :max="redirectMaxSecs"
                    :value="redirectSecs"
                    height="4px"
                ></b-progress>
              </b-alert>
              <div style="margin-top: 20px">
                <b-row class="my-1">
                  <b-col offset="3">
                    <b-button @click="reset">Change Password</b-button>
                  </b-col>
                </b-row>
              </div>
            </div>
          </div>
        </template>
      </b-jumbotron>
    </div>

</template>

<script>
  import api from '../../api.js';

  export default {
    name: "ResetPassword",
    data() {
      return {
        email: '',
        resetToken: '',

        resetTokenInvalid: false,
        successfulReset: false,

        newPassword: '',
        newPasswordConfirmation: '',

        responseText: '',
        responseError: false,

        // On success, redirect
        redirectMaxSecs: 5,
        redirectSecs: 5
      }
    },
    created () {
      // If email or reset token not defined, redirect to main page
      if(this.$router.query.email === undefined || this.$router.query.reset_token === undefined) {
        this.$router.replace('/');
      } else {
        this.email = this.$router.query.email;
        this.resetToken = this.$router.query.reset_token;
      }
    },
    methods: {
      async reset() {
        if (this.newPassword !== this.newPasswordConfirmation) {
          this.responseText = "Passwords do not match";
          this.responseError = true;
        }
        else {
          try {
            // post and wait for response
            let response = await api.reset_password.change_password(this.newPassword, this.resetToken);
            this.responseText = response.data;
            this.responseError = false;
            this.successfulReset = true;
            this.triggerRedirect();
          } catch (err) { // Error handling
            // Bad request -> validation error
            if(err.response.status === 400){
              this.responseText = err.response.data.errors[0];
              this.responseError = true;
            }
            // Unauthorized -> show error page
            else {
              this.resetTokenInvalid = true;
            }
          }
        }
      },
      async triggerRedirect(){
        let _this = this;
        let interval = undefined;
        let redirect = () => {
          if(_this.redirectSecs === 0){
            _this.$router.replace('/');
            clearInterval(interval);
          }else {
            _this.redirectSecs--;
          }
        };
        interval = setInterval(redirect, 1000);
      }
    }
  }
</script>
