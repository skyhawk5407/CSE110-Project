<template>
  <b-jumbotron>
    <template slot="header">Dashboard</template>

    <!-- edit the aprtment details here -->
    <p>Apartment Name:</p>
    <b-form-input v-model="address"></b-form-input>
     <p>Apartment Address:</p>
    <b-form-input v-model="name"></b-form-input>
    <b-button class="mt-2" variant="danger" @click="editApartmentDetails">Edit</b-button>

    <b-container class="bv-example-row">
      <b-row>
        <b-col>
          <b-card
            title="Apartment Mates"
            img-src="https://i.imgur.com/m3g0kAs.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Manage your Apartment Mates, Invite people, View contact info, or leave the Apartment.</b-card-text>

            <b-button class="mt-2" to="/ApartmentMate" variant="info">Apartment Mates</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Documents"
            img-src="https://i.imgur.com/TNef1Ww.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Upload and view your Apartment Documents such as the Lease Agreement.</b-card-text>
            <b-button class="mt-2" to="/Documents" variant="info">Documents</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Items"
            img-src="https://i.imgur.com/S1j5SmJ.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Record and organize items in the apartment such as appliances or shared items.</b-card-text>
            <b-button class="mt-2" to="/Items" variant="info">Items</b-button>
          </b-card>
        </b-col>
      </b-row>

      <b-row>
        <b-col>
          <b-card
            title="Expenses"
            img-src="https://i.imgur.com/uiXRY2e.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Add and record expenses here so Apartment Mates can also know.</b-card-text>
            <b-button class="mt-2" to="/Expenses" variant="info">Expenses</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Notifications"
            img-src="https://i.imgur.com/S1j5SmJ.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Send or read messages. A message will be sent to all Apartment Mates.</b-card-text>
            <b-button class="mt-2" to="/Notifications" variant="info">Notifications</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Account Settings"
            img-src="https://i.imgur.com/gkGlMOs.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Manage your account settings here to change your password or name.</b-card-text>
            <b-button class="mt-2" to="/AccountSettings" variant="info">Account Settings</b-button>
          </b-card>
        </b-col>
      </b-row>
    </b-container>
  </b-jumbotron>
</template>

<script>
import ApartmentMate from "./ApartmentMate";
import Notifications from "./Notifications";
import Documents from "./Documents";
import Items from "./Items";
import Expenses from "./Expenses";
import api from "../../api.js";

export default {
  name: "Dashboard",
  components: { ApartmentMate, Notifications, Documents, Items, Expenses },
  data() {
    return {
      address: "",
      name: ""
    };
  },
  created() {
    this.getApartment();
  },
  methods: {
    async getApartment() {
      let response = await api.getApt.get(
        this.$store.state.username,
        this.$store.state.password
      );
      // Only display the apartmentwide documents
      this.address = response.data.address;
      this.name = response.data.name;
    },

    async editApartmentDetails() {  try {
        let response = await api.editApartmentDetails.post(
          this.name,
          this.address
        );
      } catch (err) {
        if (err.response) {
          switch (err.response.status) {
            case 400:
              console.log(err.reponse.data);
              break;
            default:
              console.log("An unknown error occurred.");
              break;
          }
        }
      }}
  }
};
</script>
