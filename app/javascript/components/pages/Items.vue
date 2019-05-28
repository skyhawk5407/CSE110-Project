<template>
  <div>
    <b-jumbotron>
      <template slot="header">
				Items
			</template>
      <b-table
        show-empty
        stacked="md"
        :items="items"
        :fields="fields"
        :current-page="currentPage"
        :per-page="perPage"
        :filter="filter"
        :sort-by.sync="sortBy"
        :sort-desc.sync="sortDesc"
        :sort-direction="sortDirection"
        @filtered="onFiltered"
      >
        <template slot="Name" slot-scope="row">{{ row.value }}</template>

        <template
          slot="Owner"
          slot-scope="row"
        >{{ row.value.first }} {{ row.value.middle }} {{ row.value.last }}</template>

        <template slot="Actions" slot-scope="row">
          <b-button variant="primary">Edit</b-button>

          <b-button v-b-modal="'modal-2'" variant="danger">Remove</b-button>
          <b-modal id="modal-2" hide-footer title="Remove Item">
            <p>
              <b>Are you SURE you wish to remove this item?</b>
            </p>
            <p>
              <i>Note: This action can not be undone.</i>
            </p>
            <b-button class="mt-2" variant="info">No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger">Yes, I am sure.</b-button>
          </b-modal>
        </template>
      </b-table>

      <b-button v-b-modal.modal-1 variant="primary">Add Item</b-button>
      <b-modal id="modal-1" title="Add Item" ok-title="Add">
        <label>Item Name:</label>
        <b-form-input v-model="text" placeholder></b-form-input>
        <label>Owner:</label>
        <b-form-input v-model="text" placeholder></b-form-input>
      </b-modal>
    </b-jumbotron>
  </div>
</template>

<script>
export default {
  name: "Items",
  data() {
    return {
      fields: ["Name", "Owner", "Actions"],
      items: [
        {
          Name: "Microwave",
          Owner: { first: "Bob", middle: "P. ", last: "Oop" }
        },
        {
          Name: "Television",
          Owner: { first: "Charlie", middle: "M. ", last: "Smith" }
        }
      ]
    };
  },
  methods: {
    sendInvite() {
      // TODO
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
    }
  }
};
</script>