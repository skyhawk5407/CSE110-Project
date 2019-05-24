<template>
  <div>
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
      <template slot="Actions" slot-scope="row">
        <b-button variant="primary">Pay</b-button>
        <b-button v-b-modal="'modal-2'" variant="danger">Remove</b-button>
        <b-modal id="modal-2" hide-footer title="Remove Expense">
          <p>
            <b>Are you SURE you wish to remove this expense?</b>
          </p>
          <p>
            <i>Note: This action can not be undone.</i>
          </p>
          <b-button class="mt-2" variant="info">No, I am not sure.</b-button>
          <b-button class="mt-2" variant="danger">Yes, I am sure.</b-button>
        </b-modal>
      </template>
    </b-table>
    <!-- TODO: Add on click handlers into a form -->
    <!-- TODO: Allow form to be reset each time + popup email sent! -->
    <b-button v-b-modal.modal-1 variant="primary">Add Expense</b-button>

    <!-- Modal Component 1-->
    <b-modal id="modal-1" title="Add Expense">
      <label>Name of Expense:</label>
      <b-form-input v-model="expense_title" placeholder></b-form-input>
      <label>Amount:</label>
      <b-form-input v-model="expense_amount" placeholder></b-form-input>
      <label>Description:</label>
      <b-form-textarea v-model="text" rows="3"></b-form-textarea>
      <label>Payer:</label>
      <b-form-input v-model="expense_payer_id" placeholder></b-form-input>
      <b-col md="auto">
        <b-button @click="addExpense">Post</b-button>
      </b-col>
    </b-modal>
  </div>
</template>

<script>
import api from "../../api.js";

export default {
  name: "Expenses",
  data() {
    return {
      expense_payer_id: 1,
      expense_issuer_id: 2,
      expense_title: "Rent",
      expense_amount: 10000,
    };
  },
  methods: {
    // This should split the costs and submit multiple expenses to the backend
    async addExpense() {
      try {
        // post and wait for response
        let response = await api.expenses.post( this.expense_payer_id, 
        this.expense_issuer_id, this.expense_title, this.expense_amount );
        // add to table
        this.messages.push({
          message: response.data.message,
          error: false
        });
      } catch (err) {
        // Error handling
        this.messages.push({
          message: err.response.data,
          error: true
        });
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
      this.formText = "";
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