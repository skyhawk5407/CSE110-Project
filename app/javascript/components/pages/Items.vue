<template>
  <div>
    <b-jumbotron>
      <template slot="header">Items</template>
      <b-table show-empty :busy="loading" stacked="md" :items="items" :fields="fields">
        <!-- loading -->
        <div slot="table-busy" class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong>Loading...</strong>
        </div>

        <template slot="item" slot-scope="row">{{ row.value }}</template>
        <template slot="owner" slot-scope="row">{{row.value}}</template>
        <template slot="Description" slot-scope="row">{{ row.value }}</template>
        <template slot="Bought" slot-scope="row">{{Status(row.value)}}</template>

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
        <b-form-input v-model="item"></b-form-input>

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
        <b-form-textarea v-model="Description" rows="3"></b-form-textarea>

        <label>Need to Buy</label>
        <b-form-checkbox id="buyStatus" v-model="Bought">I have this item!</b-form-checkbox>
      </div>

      <b-alert class="my-3" variant="danger" :show="uploadError">{{uploadError}}</b-alert>

      <!-- action buttons -->
      <b-button class="mt-2" variant="info" @click="addItem">Add</b-button>
      <b-button class="mt-2" variant="danger" @click="hideModal('modal-addItem')">Cancel</b-button>
    </b-modal>

    <!-- Edit Popup -->
    <b-modal id="modal-edit" title="Edit Item" hide-footer>
      <div>
        <label>Item Name:</label>
        <b-form-input v-model="item"></b-form-input>

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
        <b-form-textarea v-model="Description" rows="3"></b-form-textarea>

        <label>Need to Buy</label>
        <b-form-checkbox v-model="Bought" value="true" unchecked-value="false">I have this item!</b-form-checkbox>
      </div>

      <b-alert class="my-3" variant="danger" :show="editError">{{editError}}</b-alert>

      <!-- action buttons -->
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
      <b-button class="mt-2" variant="danger" @click="removeItem">Yes, I am sure.</b-button>
      <b-button class="mt-2" variant="info" @click="hideModal('modal-remove')">No, I am not sure.</b-button>
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
      fields: ["item", "owner", "Description", "Bought", "Actions"],
      items: [],
      apartment_mates: [],
      selectedMate: null,
      selectedRow: "",
      loading: false,

      // item id and name
      item_id: null,
      item: undefined,

      // owner id and name
      owner: null,

      Bought: false,
      Description: undefined,
      curr_email: this.$store.state.username,
      curr_password: this.$store.state.password,

      uploadError: undefined,
      editError: undefined
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
      if (this.item == undefined) {
        this.uploadError = "Item name can't be blank";
        return;
      }

      try {
        // selected user info <handing null case>
        var owner_id = null;
        if (this.selectedMate != null) {
          owner_id = this.selectedMate.id;
          this.owner = this.selectedMate.display_name;
        }

        //<post data to database>
        let response = await api.items.post(
          owner_id,
          this.item,
          this.Description,
          this.Bought,
          this.curr_email,
          this.curr_password
        );

        this.loading = true;

        console.log(response.data);
<<<<<<< HEAD

        this.postItem();
        this.hideModal("modal-addItem");

=======
        this.createTable(); // Refresh table
        this.resetInput();
        this.$bvModal.hide("modal-addItem"); //close add pop-up
>>>>>>> bf6e01caa256f527de0a58c6fc4f76bdc7711ddc
        this.loading = false;
        this.uploadError = undefined;
      } catch (err) {
        if (err.response) {
          this.uploadError = err.response.data.errors[0];
        }
<<<<<<< HEAD
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
          item_id: lastTransactionEntry.id,
          item: lastTransactionEntry.name,
          owner: lastTransactionEntry.owner_name,
          Description: lastTransactionEntry.description,
          Bought: lastTransactionEntry.bought
        });
      } catch (err) {
        console.log("fail");
=======
>>>>>>> bf6e01caa256f527de0a58c6fc4f76bdc7711ddc
      }
    },

    // get entire items
    async createTable() {
      this.loading = true;

      let response = await api.items.get(this.curr_email, this.curr_password);
      var transactions = response.data;
      var i = 0;

      this.items = [];
      for (i in transactions) {
        var entry = transactions[i];

        if (entry.id == null) {
          entry.display_name = "N/A";
          console.log("apt_mate.display_name");
          console.log(": " + entry.display_name);
        }
        var load = {
          item_id: entry.id,
          item: entry.name,
          owner: entry.owner_name,
          Description: entry.description,
          Bought: entry.bought
        };
        this.items.push(load);
      }
      this.loading = false;
    },
    async removeItem() {
      try {
        var deleteCount = 1;
        var index = this.items.indexOf(this.selectedRow);
        var itemId = this.items[index].item_id;

        // backend delete
        let response = await api.items.delete(
          itemId,
          this.curr_email,
          this.curr_password
        );

        // frontend delete
        this.items.splice(index, deleteCount);

        // close
        this.hideModal("modal-remove");
      } catch (err) {
        console.log(err);
      }
    },

    async getEditItem(selectedRow) {
      this.selectedRow = selectedRow;

      var index = this.items.indexOf(selectedRow);

      this.item_id = this.items[index].item_id;
      this.item = this.items[index].item;
      this.owner = this.items[index].owner;
      this.Description = this.items[index].Description;
      this.Bought = this.items[index].Bought;
      console.log("owner: " + this.items[index].owner);
    },
    async editItem() {
      try {
        // console.log("selectedMate: " + this.selectedMate.id);

        var owner_id = null;
        this.owner = "N/A";

        if (this.selectedMate != null) {
          owner_id = this.selectedMate.id;
          this.owner = this.selectedMate.display_name;
        }
        console.log("this id" + owner_id);
        console.log("this ower" + this.owner);

        let response = await api.items.update(
          this.item_id,
          owner_id,
          this.item,
          this.Description,
          this.Bought,
          this.curr_email,
          this.curr_password
        );
        console.log("Bought:::: " + this.Bought);

        // console.log("item_id id: " + this.item_id);
        // console.log("owner id: " + owner_id);
        // console.log("owner name: " + this.owner);
        // console.log("item: " + this.item);
        // console.log("curr_email: " + this.curr_email);
        // console.log("curr_pass: " + this.curr_password);
        // console.log(response.data);

        // set changed data to table
        var index = this.items.indexOf(this.selectedRow);
        this.$set(this.items[index], "item", this.item);
        this.$set(this.items[index], "owner", this.owner);
        this.$set(this.items[index], "Description", this.Description);
        this.$set(this.items[index], "Bought", this.Bought);

<<<<<<< HEAD
        this.hideModal("modal-edit");
=======
        this.resetInput();
        this.$bvModal.hide("modal-edit");
        this.editError = undefined;
>>>>>>> bf6e01caa256f527de0a58c6fc4f76bdc7711ddc
      } catch (err) {
        if (err.response) {
          this.editError = err.response.data.errors[0];
        }
      }
    },
    Status(bought) {
      console.log("bought:: " + bought);

      if (bought == true || bought == "true") {
        return "Yes";
      } else {
        return "No";
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
      this.item_id = null;
      this.item = undefined;
      this.owner = null;
      this.Bought = true;
      this.Description = undefined;
    },
    sendInfo(row) {
      this.selectedRow = row;
    }
  }
};
</script>