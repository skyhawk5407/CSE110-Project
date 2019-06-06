<template>
  <div>
    <b-jumbotron>
      <b-table show-empty :busy="loading" stacked="md" :items="items" :fields="fields">
        <div slot="table-busy" class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong>Loading...</strong>
        </div>

        <template slot="Name" slot-scope="row">{{ row.value }}</template>
        <template slot="Owner" slot-scope="row">{{row.value}}</template>
        <template slot="Description" slot-scope="row">{{ row.value }}</template>
        <!-- <template slot="Status" slot-scope="row">{{ row.value }}</template> -->

        <!-- Edit&Remove -->
        <template slot="Actions" slot-scope="row">
          <b-button v-b-modal.modal-edit variant="primary" @click="getEditItem(row.item)">Edit</b-button>
          <b-button v-b-modal="'modal-remove'" variant="danger" @click="sendInfo(row.item)">Remove</b-button>
        </template>
      </b-table>

      <!-- Add -->
      <b-button v-b-modal.modal-addItem variant="primary">Add Item</b-button>
    </b-jumbotron>

    <!-- Add Popup -->
    <b-modal id="modal-addItem" title="Add Item" hide-footer>
      <div>
        <label>Item Name:</label>
        <b-form-input v-model="Name"></b-form-input>

        <label>Owner:</label>
        <b-form-select v-model="selectedMate">
          <option
            v-for="user in apartment_mates"
            v-bind:key="user.id"
            v-bind:value="user"
          >{{user.display_name}}</option>
          <template slot="first">
            <option :value="null">N/A</option>
          </template>
        </b-form-select>

        <label>Description:</label>
        <b-form-input v-model="Description" rows="3"></b-form-input>
        <!-- 
      <label>Status</label>
        <b-form-checkbox id="buyStatus" v-model="Status" value="true" unchecked-value="false"></b-form-checkbox>-->
      </div>

      <b-button class="mt-2" variant="info" @click="addItem">Add</b-button>
      <b-button class="mt-2" variant="danger" @click="hideModal('modal-addItem')">Cancel</b-button>
    </b-modal>

    <!-- Edit Popup -->
    <b-modal id="modal-edit" title="Edit Item" hide-footer>
      <div>
        <label>Item Name:</label>
        <b-form-input v-model="Name"></b-form-input>

        <label>Owner:</label>
        <b-form-select v-model="selectedMate">
          <option
            v-for="user in apartment_mates"
            v-bind:key="user.id"
            v-bind:value="user"
          >{{user.display_name}}</option>
          <template slot="first">
            <option :value="null">N/A</option>
          </template>
        </b-form-select>

        <label>Description:</label>
        <b-form-input v-model="Description" rows="3"></b-form-input>

        <!-- <label>Need to Buy</label>
      <b-form-checkbox id="buyStatus" v-model="Status">
        <b-form-checkbox value="true">Have</b-form-checkbox>
        <b-form-checkbox value="false">Don't Have</b-form-checkbox>
        </b-form-checkbox>-->
      </div>
      <b-button class="mt-2" variant="info" @click="editItem">Save</b-button>
      <b-button class="mt-2" variant="danger" @click="hideModal('modal-edit')">Cancel</b-button>
    </b-modal>

    <!-- Remove Popup -->
    <b-modal id="modal-remove" hide-footer title="Remove Item">
      <p>
        <b>Are you SURE you wish to remove this item?</b>
      </p>
      <p>
        <i>Note: This action can not be undone.</i>
      </p>
      <b-button class="mt-2" variant="info" @click="hideModal('modal-remove')">No, I am not sure.</b-button>
      <b-button class="mt-2" variant="danger" @click="removeItem('modal-remove')">Yes, I am sure.</b-button>
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
      fields: ["Name", "Owner", "Description", /*"Status",*/ "Actions"],
      items: [],
      apartment_mates: [],
      selectedMate: null,
      selectedRow: "",
      loading: false,

      Id: null,
      Name: undefined,
      owner_id: null,
      Owner: null,
      Status: false,
      Description: undefined,
      curr_email: this.$store.state.username,
      curr_password: this.$store.state.password
    };
  },
  created() {
    this.extractMates();
    this.createTable();
  },
  methods: {
    async extractMates() {
      // find user name and id
      let response = await api.getApt.get(this.curr_email, this.curr_password);
      var mate_list = response.data.users;
      for (var i = 0; i < mate_list.length; i++) {
        var apt_mate = mate_list[i];
        this.apartment_mates.push({
          id: apt_mate.id,
          display_name: apt_mate.display_name
        });
      }
    },
    async addItem() {
      try {
        this.loading = true;

        console.log("id: " + this.selectedMate.id);

        let response = await api.items.post(
          this.selectedMate.id,
          this.Name,
          this.Description,
          this.curr_email,
          this.curr_password
        );
        console.log(response.data);
        this.postItem();
        this.resetInput();
        this.$bvModal.hide("modal-addItem");
        this.loading = false;
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
    async postItem() {
      try {
        console.log("push");
        let response = await api.items.get(this.curr_email, this.curr_password);
        var transactions = response.data;
        var lastTransactionId = transactions.length - 1;
        var lastTransactionEntry = transactions.find(
          function findLastTransaction(element, index, array) {
            var lastTransactionId = array.length - 1;
            return element == lastTransactionId || index == lastTransactionId;
          },
          lastTransactionId
        );

        // post Item
        this.items.push({
          Id: lastTransactionEntry.id,
          Name: lastTransactionEntry.name,
          Owner: lastTransactionEntry.owner_name,
          Description: lastTransactionEntry.description
        });
      } catch (err) {
        console.log("fail");
      }
    },

    // get entire items
    async createTable() {
      this.loading = true;
      let response = await api.items.get(this.curr_email, this.curr_password);
      var transactions = response.data;
      var i = 0;

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
      this.loading = false;
    },
    async removeItem(modal) {
      try {
        var deleteCount = 1;
        // delete from database
        var index = this.items.indexOf(this.selectedRow);
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

    async getEditItem(selectedRow) {
      this.selectedRow = selectedRow;
      var index = this.items.indexOf(selectedRow);
      this.Id = this.items[index].Id;
      this.Name = this.items[index].Name;
      this.Description = this.items[index].Description;
      this.Owner = this.items[index].Owner;
      console.log("Owner: " + this.items[index].Owner);
    },
    async editItem() {
      console.log("Edit...");
      try {
        let response = await api.items.update(
          this.Id,
          this.selectedMate.id,
          this.Name,
          this.Description,
          this.curr_email,
          this.curr_password
        );

        // set changed data to table
        var index = this.items.indexOf(this.selectedRow);
        this.$set(this.items[index], "Name", this.Name);
        this.$set(this.items[index], "Owner", this.selectedMate.display_name);
        this.$set(this.items[index], "Description", this.Description);
        this.resetInput();
        this.$bvModal.hide("modal-edit");
      } catch (err) {
        console.log(err);
        this.messages.push({
          message: err,
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
      this.resetInput();
      this.$root.$emit("bv::hide::modal", modal, "#btnShow");
    },
    resetInput() {
      this.Id = null;
      this.Name = undefined;
      this.owner_id = null;
      this.Owner = null;
      this.Status = false;
      this.Description = undefined;
    },
    sendInfo(row) {
      this.selectedRow = row;
    }
  }
};
</script>