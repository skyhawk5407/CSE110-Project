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
              <b-form-input v-model="login_password_text" type="password" placeholder="Password"
                            @keyup.enter="login"></b-form-input>
            </b-col>
          </b-row>
          <b-alert variant="danger" :show="show_login_fail">{{ isSuccess }}</b-alert>
          <b-alert variant="info" :show="!show_login_fail && emailSent">Password Reset email sent</b-alert>
        </div>
        <div style="margin-top: 20px">
          <b-form-checkbox v-model="remember_me">Remember me</b-form-checkbox>
        </div>
        <div style="margin-top: 20px">
          <b-button class="btn" variant="success" @keyup.enter="login" @click="login">Login</b-button>
          <b-button class="btn" to="AccountCreation" variant="info">Create Account</b-button>
          <b-button class="btn" v-b-modal="'modal-1'" variant="info">Forgot Password</b-button>

          <b-modal ref="recoverModal" id="modal-1" title="Account Recovery" @ok="requestReset">
            <label>E-mail:</label>
            <b-form-input v-model="resetPasswordText" placeholder=""></b-form-input>
            <b-alert class="my-3" variant="danger" :show="invalidReset">{{resetError}}</b-alert>
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

        resetPasswordText: undefined,
        emailSent: false,
        invalidReset: false,
        resetError: ''
      }
    },
    methods: {
      async login() {
        try {
          this.emailSent = false;
          let response = await api.users.login.get(this.login_email_text,
              this.login_password_text);
          // TODO: Login permanence if remember me is checked
          if (this.remember_me) {
            this.$cookie.set('username', this.login_email_text, 30);
            this.$cookie.set('password', this.login_password_text, 30);
            this.$cookie.set('displayName', response.data.display_name, 30);
            this.$cookie.set('phoneNumber', response.data.phone_number, 30);
            this.$cookie.set('apartmentId', response.data.apartment_id, 30);
            this.$cookie.set('isPermanence', true, 30);
          } else {
            this.$cookie.set('isPermanence', false, 30);
          }

          this.$store.commit('setUsername', this.login_email_text);
          this.$store.commit('setPassword', this.login_password_text);
          this.$store.commit('setDisplayName', response.data.display_name);
          this.$store.commit('setPhoneNumber', response.data.phone_number);
          this.$store.commit('setApartmentId', response.data.apartment_id);

          if (response.data.apartment_id == null) {
            this.$router.push({path: 'Dashboardi'});
          } else {
            this.$router.push({path: 'Dashboard'});
          }

          this.show_login_fail = false;
        } catch (err) {
          this.$store.commit("setUsername", undefined);
          this.$store.commit("setPassword", undefined);
          this.$store.commit("setDisplayName", undefined);
          this.$store.commit("setPhoneNumber", undefined);
          this.$store.commit("setApartmentId", undefined);

          this.$cookie.delete('username');
          this.$cookie.delete('password');
          this.$cookie.delete('displayName');
          this.$cookie.delete('phoneNumber');
          this.$cookie.delete('apartmentId');
          
          this.isSuccess = err.response.data.errors[0];
          this.show_login_fail = true;
        }
      },
      async requestReset(modal) {
        modal.preventDefault();
        try {
          await api.reset_password.issue_reset_token(this.resetPasswordText);
          this.$refs.recoverModal.hide();
          this.emailSent = true;
          this.invalidReset = false;
        } catch (err) {
          if(err.response){
            this.resetError = err.response.data.errors[0];
            this.invalidReset = true;
          }
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
