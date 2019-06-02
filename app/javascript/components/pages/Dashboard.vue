<template>
  <b-jumbotron>
    <template slot="header">Dashboard</template>
    <b-container class="bv-example-row">
      <b-row>
        <b-col>
          <b-card
            title="Apartment Mates"
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
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
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
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
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
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
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Add and record expenses here so your Aprtment Mates can also know.</b-card-text>
            <b-button class="mt-2" to="/Expenses" variant="info">Expenses</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Notifications"
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Send or read messages within the apartment. An message will be sent to all Apartment Mates</b-card-text>
            <b-button class="mt-2" to="/Notifications" variant="info">Notifications</b-button>
          </b-card>
        </b-col>

        <b-col>
          <b-card
            title="Account Settings"
            img-src="https://www.pngfind.com/pngs/m/70-707227_poo-emoji-transparent-animated-emoji-poop-hd-png.png"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-text>Manage your account settings here to change your password or username.</b-card-text>
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
import Rules from "./Rules";

export default {
  name: "Dashboard",
  components: {
    ApartmentMate,
    Notifications,
    Documents,
    Items,
    Expenses,
    Rules
  }
};
</script>
