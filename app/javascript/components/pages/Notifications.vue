<template>
  <div>
    <b-jumbotron>
      <template slot="header">Notifications</template>

      <b-table show-empty stacked="md" :items="notification_entries" :fields="fields">
        <!-- Props to b-table to add later TODO -->
        <!-- :filter="filter"
      :sort-by.sync="sortBy"
      :sort-desc.sync="sortDesc"
      :sort-direction="sortDirection"
        @filtered="onFiltered"-->
        <!-- Data -->
        <template slot="Date" slot-scope="row">{{ row.value }}</template>
        <template slot="Subject" slot-scope="row">{{ row.value }}</template>
        <template slot="Message" slot-scope="row">{{ row.value }}</template>
        <!-- {{ col.value.first }} {{ col.value.middle }} {{ col.value.last }} -->
        <template slot="Description" slot-scope="row">{{ row.value }}</template>
        <!-- Actions -->
        <template slot="Actions" slot-scope="row">
          {{row.value}}
          <b-button variant="primary" @click="readNotification">Mark read</b-button>
        </template>
      </b-table>
      <!-- TODO: Add on click handlers into a form -->
      <!-- TODO: Allow form to be reset each time + popup email sent! -->
      <b-button v-b-modal.modal-1 variant="primary">Create Notification</b-button>
      <b-modal id="modal-1" title="Create Notification" @ok="sendNotification">
        <label>Subject:</label>
        <b-form-input v-model="title"></b-form-input>
        <label>Description:</label>
        <b-form-textarea v-model="message"></b-form-textarea>
      </b-modal>

      <!--template slot="lead">
                <div style="margin-top: 20px">
                    <b-row class="my-1">
                        <b-col>
                            <b-form-input v-model="title" placeholder="Subject"></b-form-input>
                            <b-form-textarea v-model="message" placeholder="Message" rows="4"></b-form-textarea>
                        </b-col>
                    </b-row>
                </div>
                <div style="margin-top: 20px">
                    <b-button variant="info" @click="sendNotification">Send Notification</b-button>
                </div>
      </template-->
      <b-alert variant="danger" :show="invalidField">{{fieldError}}</b-alert>
    </b-jumbotron>
  </div>
</template>

<script>
import api from "../../api.js";
export default {
  name: "Notifications",
  data() {
    return {
      title: "",
      message: "",
      invalidField: false,
      fieldError: "",
      fields: ["Date", "Subject", "Message", "Actions"],
      notification_entries: [
        {
          Date: "5/30/2019",
          Subject: "Hello",
          Message:
            "Welcome to TURDMate! To access each module, navigate to the top and click the button on the NavBar."
        }
      ]
    };
  },
  methods: {
    async sendNotification() {
      try {
        // post and wait for response
        console.log(this.title);
        console.log(this.message);
        let response = await api.notification.post(
          this.title,
          this.message,
          this.$store.state.username,
          this.$store.state.password
        );
        this.invalidField = false;

        console.log(response.status);
        console.log(response.data);

        // call get Notification to populate
        this.getNotification(true);
      } catch (err) {
        // Error handling
        if (err.response) {
          switch (err.response.status) {
            case 400: // Bad request
              console.log("Bad request");
              this.invalidField = true;
              this.fieldError = err.response.data.errors[0];
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


    },
    async getNotification(single) {
      try {
        // get Notification
        let response = await api.notification.get(
          this.$store.state.username,
          this.$store.state.password
        );

        var notifications = response.data;
        var notificationId;
        if (single == true) {
          notificationId = notifications.length - 1;
        } else {
          notificationId = 0;
        }
        for (var i = notificationId; i < notifications.length; i++) {
          console.log(response.data[i].id);
          var lastNotificationEntry = notifications.find(
            function findLastNotification(element, index, array) {
              return element == i || index == i;
            },
            notificationId
          );
          // add to table
          this.notification_entries.push({
            Date: lastNotificationEntry.created_at,
            Subject: lastNotificationEntry.title,
            Message: lastNotificationEntry.message
          });
        }
      } catch (err) {
        // Error handling
        if (err.response) {
          switch (err.response.status) {
            case 400: // Bad request
              console.log("Bad request");
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

    async readNotification() {}
  },
  beforeMount() {
    this.getNotification(false);
  }
};
</script>