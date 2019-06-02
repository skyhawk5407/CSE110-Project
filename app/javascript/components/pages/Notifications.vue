<template>
  <div>
    <b-jumbotron>
      <template slot="header">Notifications</template>

      <b-table show-empty stacked="md" :items="notification_entries" :fields="fields">
        <!-- Data -->
        <template slot="Date" slot-scope="row">{{ row.value }}</template>
        <template slot="Sender" slot-scope="row">{{ row.value }}</template>
        <template slot="Subject" slot-scope="row">{{ row.value }}</template>
        <template slot="Message" slot-scope="row">{{ row.value }}</template>
        <!-- Actions -->
        <template slot="Actions" slot-scope="row">
          {{row.value}}
          <b-button variant="primary" @click="readNotification(row.index + 1)">Mark read</b-button>
        </template>
      </b-table>
      <b-button v-b-modal.modal-notification variant="primary">Create Notification</b-button>
      <b-modal id="modal-notification" title="Create Notification" @ok="sendNotification" ok-title="Send Notification">
        <label>Subject:</label>
        <b-form-input v-model="title"></b-form-input>
        <label>Message:</label>
        <b-form-textarea v-model="message"></b-form-textarea>
        <b-form-checkbox v-model="anonymous">Anonymous</b-form-checkbox>
      </b-modal>
      <b-alert variant="danger" :show="invalidRequest">{{requestError}}</b-alert>
    </b-jumbotron>
  </div>
</template>

<script>
import api from "../../api.js";
import moment from "moment";

export default {
  name: "Notifications",
  data() {
    return {
      title: "",
      message: "",
      anonymous: false,
      invalidRequest: false,
      requestError: "",
      fields: ["Date", "Sender", "Subject", "Message", "Actions"],
      notification_entries: []
    };
  },
  methods: {
    async sendNotification() {
      try {
        // post and wait for response
        // console.log(this.title);
        // console.log(this.message);
        let response = await api.notification.post(
          this.title,
          this.message,
          this.anonymous,
          this.$store.state.username,
          this.$store.state.password
        );
        this.invalidRequest = false;

        // console.log(response.status);
        // console.log(response.data);

        // call get Notification to populate
        this.getNotification(true);
      } catch (err) {
        // Error handling
        if (err.response) {
          switch (err.response.status) {
            case 400: // Bad request
              console.log("Bad request");
              this.invalidRequest = true;
              this.requestError = err.response.data.errors[0];
              break;
            default:
              // 500
              console.log("An unknown error occurred.");
              break;
          }
        }
      }

      // clear form after submit
      this.title = "";
      this.message = "";
      this.anonymous = false;
    },
    async getNotification(single) {
      try {
        // get Notification
        let response = await api.notification.get(
          this.$store.state.username,
          this.$store.state.password
        );
        this.invalidRequest = false;

        var notifications = response.data;
        var notificationId;
        if (single == true) {
          notificationId = notifications.length - 1;
        } else {
          notificationId = 0;
        }
        // console.log(notifications);
        for (var i = notificationId; i < notifications.length; i++) {
          // console.log(response.data[i].id);
          // add to table
          this.notification_entries.push({
            Date: moment(notifications[i].created_at).format("MM/DD/YYYY"),
            Sender: notifications[i].creator_name,
            Subject: notifications[i].title,
            Message: notifications[i].message,
          });
        }
      } catch (err) {
        // Error handling
        if (err.response) {
          switch (err.response.status) {
            case 400: // Bad request
              console.log("Bad request");
              this.invalidRequest = true;
              this.requestError = err.response.data.errors[0];
              break;
            default:
              // 500
              console.log("An unknown error occurred.");
              break;
          }
        }
        console.log(err);
      }
    },

    async readNotification(index) {
      try {
        let response = await api.markRead.post(
          index,
          this.$store.state.username,
          this.$store.state.password
        );
        this.invalidRequest = false;
        // console.log(response);
      } catch (err) {
        // Error handling
        if (err.response) {
          switch (err.response.status) {
            case 400: // Bad request
              console.log("Bad request");
              this.invalidRequest = true;
              this.requestError = err.response.data.errors[0];
              break;
            default:
              // 500
              console.log("An unknown error occurred.");
              break;
          }
        }
        console.log(err);
      }
    }
  },
  created() {
    this.getNotification(false);
  }
};
</script>
