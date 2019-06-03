<template>
  <div>
    <b-jumbotron>
      <template slot="header">Items</template>
      <b-table show-empty stacked="md" :items="items" :fields="fields">
        <template slot="Name" slot-scope="row">{{ row.value }}</template>
        <template slot="Owner" slot-scope="row">{{row.value}}</template>
        <template slot="Description" slot-scope="row">{{ row.value }}</template>

        <!-- Edit&Remove -->
        <template slot="Actions" slot-scope="row">
          <b-button v-b-modal.modal-2 variant="primary" @click="sendInfo(row.item)">Edit</b-button>
          <b-button v-b-modal="'my_modal_items'" variant="danger" @click="sendInfo(row.item)">Remove</b-button>
        </template>
      </b-table>

      <!-- Add -->
      <b-button v-b-modal.modal-1 variant="primary">Add Item</b-button>
    </b-jumbotron>

    <!-- Add Popup -->
    <b-modal id="modal-1" title="Add Item" @ok="addItem" ok-title="Add">
      <label>Item Name:</label>
      <b-form-input v-model="Name"></b-form-input>
      <label>Description:</label>
      <b-form-input v-model="Description" row="2"></b-form-input>
    </b-modal>

    <!-- Edit Popup -->
    <b-modal
      id="modal-2"
      title="Edit Item"
      @ok="editItem(selectedRow, 'my_modal_items')"
      ok-title="Save"
    >
      <label>Item Name:</label>
      <b-form-input v-model="Name"></b-form-input>
      <label>Description:</label>
      <b-form-input v-model="Description" row="2"></b-form-input>
    </b-modal>

    <!-- Remove Popup -->
    <b-modal id="my_modal_items" hide-footer title="Remove Item">
      <p>
        <b>Are you SURE you wish to remove this item?</b>
      </p>
      <p>
        <i>Note: This action can not be undone.</i>
      </p>
      <b-button class="mt-2" variant="info" @click="hideModal('my_modal_items')">No, I am not sure.</b-button>
      <b-button
        class="mt-2"
        variant="danger"
        @click="removeItem(selectedRow, 'my_modal_items')"
      >Yes, I am sure.</b-button>
    </b-modal>
  </div>
</template>

<script>
import api from "../../api.js";

export default {
  name: "Items",
  data() {
    return {
      messages: [
        {
          message: "",
          error: false
        }
      ],
      fields: ["Name", "Owner", "Description", "Actions"],
      items: [],
      selectedRow: "",

      Id: null,
      Name: undefined,
      owner_id: null,
      Owner: undefined,
      Description: undefined,
      curr_email: this.$store.state.username,
      curr_password: this.$store.state.password
    };
  },
  created() {
    this.extractMates();
    this.getAllItems();
  },
  methods: {
    async extractMates() {
      // find user name and id
      let response = await api.getApt.get(this.curr_email, this.curr_password);
      var mate_list = response.data.users;
      for (var i = 0; i < mate_list.length; i++) {
        var apt_mate = mate_list[i];
        if (apt_mate.email == this.$store.state.username) {
          this.owner_id = apt_mate.id;
          this.Owner = apt_mate.display_name;
        }
      }
    },
    async addItem() {
      try {
        // add to database
        let response = await api.items.post(
          this.owner_id,
          this.Name,
          this.Description,
          this.curr_email,
          this.curr_password
        );

        this.getItems();
      } catch (err) {
        this.messages.push({
          message: err.response.data,
          error: true
        });
        if (err.response) {
          switch (err.response.status) {
            case 400:
              console.log("error");
              break;
            default:
              console.log("unknown error");
          }
        }
      }
    },
    async getItems() {
      try {
        console.log("getItems");
        let response = await api.items.get(this.curr_email, this.curr_password);
        var transactions = response.data;
        var lastTransactionId = transactions.length - 1;
        // This data contains all the data for the last transaction
        var lastTransactionEntry = transactions.find(
          function findLastTransaction(element, index, array) {
            var lastTransactionId = array.length - 1;
            return element == lastTransactionId || index == lastTransactionId;
          },
          lastTransactionId
        );

        this.items.push({
          Id: lastTransactionEntry.id,
          Name: lastTransactionEntry.name,
          Owner: lastTransactionEntry.owner_name,
          Description: lastTransactionEntry.description
        });
      } catch (err) {
        console.log("fail");
      }
      this.Name = this.Name;
      this.Description = this.Description;
    },
    // et entire items
    async getAllItems() {
      let response = await api.items.get(this.curr_email, this.curr_password);
      var transactions = response.data;
      var i = 0;

      //
      for (i in transactions) {
        var entry = transactions[i];
        var load = {
          Id: entry.id,
          Name: entry.name,
          Owner: entry.owner_name,
          Description: entry.description
        };
        this.items.push(load);
      }
    },
    async removeItem(selectedRow, modal) {
      try {
        var deleteCount = 1;

        // delete from database
        var index = this.items.indexOf(selectedRow);
        var item_id = this.items[index].Id;
        let response = await api.items.delete(
          item_id,
          this.curr_email,
          this.curr_password
        );

        // frontend delete
        this.items.splice(index, deleteCount);

        // close
        this.hideModal(modal);
      } catch (err) {
        this.messages.push({
          message: err.response.data,
          error: true
        });
        if (err.response) {
          switch (err.response.status) {
            case 400:
              console.log("error");
              break;
            default:
              console.log("unknown error");
          }
        }
      }
    },
    async editItem(selectedRow, modal) {
      let response = await api.items.get(this.curr_email, this.curr_password);
      var transactions = response.data;
      var lastTransactionId = this.items.indexOf(selectedRow);
      // This data contains all the data for the last transaction
      var lastTransactionEntry = transactions.find(function findLastTransaction(
        element,
        index,
        array
      ) {
        var lastTransactionId = array.length - 1;
        return element == lastTransactionId || index == lastTransactionId;
      },
      lastTransactionId);
      console.log("last ID: " + lastTransactionId);
    },
    handleSubmit() {
      // Exit when the form isn't valid
      if (!this.checkFormValidity()) {
        return;
      }
      // Push the name to submitted names
      this.submittedNames.push(this.name);
      // Hide the modal manually
      this.$nextTick(() => {
        this.$refs.modal.hide();
      });
    },
    hideModal(modal) {
      this.$root.$emit("bv::hide::modal", modal, "#btnShow");
    },
    toggleModal(modal, row) {
      console.log(row);
      this.items = this.getItems();
      this.$root.$emit("bv::toggle::modal", modal, "#btnToggle");
    },
    openWindow(url) {
      window.open(url, "_blank");
    },
    sendInfo(row) {
      this.selectedRow = row;
    }
  }
};
</script>
