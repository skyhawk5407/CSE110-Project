<template>
  <b-jumbotron>
    <template slot="header">Dashboard</template>
    <b-container class="bv-example-row">
      <b-row>
        <b-col>
          <h3>ApartmentMates</h3>
		  <b-button class="mt-2" to="/ApartmentMate" variant="info">Apartment Mates</b-button>
          <p>Manage your Apartment Mates, View contact info, or leave the Apartment. </p>
        </b-col>

        <b-col>
          <h3>Documents</h3>
          <b-button class="mt-2" to="/Documents" variant="info">Documents</b-button>
          <p>View your Apartment Documents.</p>
        </b-col>

        <b-col>
          <h3>Items</h3>
          <b-button class="mt-2" to="/Items" variant="info">Items</b-button>
          <p>Record and organize items in the apartment such as appliances.</p>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <h3>Expenses</h3>
          <b-button class="mt-2" to="/Expenses" variant="info">Expenses</b-button>
          <p>Add and record expenses here so your Aprtment Mates can also know.</p>
        </b-col>

        <b-col>
          <h3>Notifications</h3>
          <b-button class="mt-2" to="/Notifications" variant="info">Notifications</b-button>
          <p>Send or read messages within the apartment.</p>
        </b-col>

        <b-col>
          <h3>Account Settings</h3>
          <b-button class="mt-2" to="/AccountSettings" variant="info">Account Settings</b-button>
          <p>Manage your account settings here.</p>
        </b-col>
      </b-row>
    </b-container>
  </b-jumbotron>
</template>

<script>
	import ApartmentMate from './ApartmentMate';
	import Notifications from './Notifications';
	import Documents from './Documents';
	import Items from './Items';
	import Expenses from "./Expenses";

    export default {
        name: "Dashboard",
        components: {ApartmentMate, Notifications, Documents, Items, Expenses}
    }
</script>
