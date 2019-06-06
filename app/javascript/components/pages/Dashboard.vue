<template>
  <b-jumbotron>
    <template slot="header">
      Dashboard
    </template>

    <template slot="lead">
      Welcome to <i>{{ name }}</i> at {{address}}!
    </template>

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
            title="Settings"
            img-src="https://i.imgur.com/gkGlMOs.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Manage your account settings, or edit the details of the apartment.</b-card-text>
            <b-button-toolbar>
              <b-button to="/AccountSettings" variant="info">Account</b-button>
              <b-button class="mx-1" v-b-modal.editApartmentModal variant="info">Apartment</b-button>
            </b-button-toolbar>
          </b-card>
        </b-col>
      </b-row>
    </b-container>

    <b-modal id="editApartmentModal"
             ref="editApartmentModal"
             hide-footer
             title="Edit Apartment Settings">
      <label>Apartment Name:</label>
      <b-form-input class="mb-3"v-model="changeName"></b-form-input>
      <label>Apartment Address:</label>
      <b-form-input class="my-3" v-model="changeAddress"></b-form-input>

      <b-button variant="info"
                @click="editApartmentDetails">
        Edit
      </b-button>
      <b-button variant="secondary"
                @click="$refs.editApartmentModal.hide()">
        Cancel
      </b-button>
      <b-alert class="my-3" variant="danger" :show="errorText">{{errorText}}</b-alert>
    </b-modal>
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
      name: "",

      changeName: "",
      changeAddress: "",
      errorText: undefined
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
      this.changeAddress = this.address;
      this.changeName = this.name;
    },

    async editApartmentDetails(e) {
      e.preventDefault();
      try {
        let response = await api.editApartmentDetails.post(
          this.changeName,
          this.changeAddress,
          this.$store.state.username,
          this.$store.state.password,
        );
        this.errorText = undefined;
        this.name = this.changeName;
        this.address = this.changeAddress;
        this.$refs.editApartmentModal.hide();
      } catch (err) {
        if (err.response) {
          this.errorText = err.response.data.errors[0];
        }
      }}
  }
};
</script>
