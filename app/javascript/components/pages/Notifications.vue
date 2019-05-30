<template>
  <div>
    <b-jumbotron>
      <template slot="header">Notifications</template>

      <b-table show-empty stacked="md" :items="expense_entries" :fields="fields">
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
      fields: ["Date", "Subject", "Message", "Actions"],
      expense_entries: [
        {
          Date: "5/23/2019",
          Subject: "Hello",
          Message:
            "Welcome to the apartment! To access all the modules, go to the top part and click on the NavBar"
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
          "jsmith@example.com",
          "password123"
        );

        console.log(response.status);
        console.log(response.data);
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
      }

      // clear form after submit
      this.title = "";
      this.message = "";

      // call get Notification to populate
      this.getNotification();
    },
    async getNotification() {
      try {
        // get Notification
        let response = await api.notification.get(
          "jsmith@example.com",
          "password123"
        );

        var notifications = response.data;
        var currId = response.data[0].id;
        var lastNotificationId = notifications.length - 1;
        console.log(response);
        // This data contains all the data for the last notification
        var lastNotificationEntry = notifications.find(
          function findLastTransaction(element, index, array) {
            var lastNotificationId = array.length - 1;
            return element == lastNotificationId || index == lastNotificationId;
          },
          lastNotificationId
        );
        // add to table
        this.expense_entries.push({
          Date: lastNotificationEntry.created_at,
          Subject: lastNotificationEntry.title,
          Message: lastNotificationEntry.message
        });
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

    async readNotification() {
        
    }
  }
};
</script>