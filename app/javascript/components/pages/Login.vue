<template>
  <div>
    <b-jumbotron>
      <template slot="header">Login</template>
      <template slot="lead">
        <div style="margin-top: 50px">
          <b-row class="my-1">
            <b-col sm="1">
              <label>E-mail:</label>
            </b-col>
            <b-col sm="6">
              <b-form-input v-model="text" placeholder></b-form-input>
            </b-col>
          </b-row>
          <b-row class="my-1">
            <b-col sm="1">
              <label>Password:</label>
            </b-col>
            <b-col sm="6">
              <b-form-input v-model="text" placeholder></b-form-input>
            </b-col>
          </b-row>
        </div>
        <div style="margin-left: 105px; margin-top: 20px">
          <b-form-checkbox class="mb-2 mr-sm-2 mb-sm-0">Remember me</b-form-checkbox>
        </div>
        <div style="margin-left: 105px; margin-top: 20px">
          <b-button>Login</b-button>
          <a href="url" color="red">Create an Account</a>
        </div>
      </template>
    </b-jumbotron>
  </div>
</template>

<script>
export default {
  name: "One"
};
</script>
