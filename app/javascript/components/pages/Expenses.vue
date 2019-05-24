<template>
  <div>
    <b-table
      show-empty
      stacked="md"
      :items="expense_entries"
      :fields="fields"
      :filter="filter"
      :sort-by.sync="sortBy"
      :sort-desc.sync="sortDesc"
      :sort-direction="sortDirection"
      @filtered="onFiltered"
    >
      <!-- Data -->
      <template slot="Date" slot-scope="col">{{ col.value }}</template>
      <template slot="Expense" slot-scope="col">{{ col.value }}</template>
      <template slot="Amount" slot-scope="col">{{ col.value }}</template>
      <template slot="Issuer" slot-scope="col">{{ col.value }}</template>
      <template
        slot="Payers"
        slot-scope="col"
      >{{ col.value.first }} {{ col.value.middle }} {{ col.value.last }}</template>
      <template slot="Description" slot-scope="col">{{ col.value }}</template>
      <!-- Actions -->
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
      <b-form-input v-model="expense_title"></b-form-input>
      <label>Amount:</label>
      <b-form-input v-model="expense_amount"></b-form-input>
      <label>Description:</label>
      <b-form-textarea v-model="text" rows="3"></b-form-textarea>
      <label>Payer:</label>
      <b-form-input v-model="expense_payer_id"></b-form-input>
      <b-col md="auto">
        <b-button @click="addExpense">Post</b-button>
      </b-col>
      <!-- <b-col>
        <b-button @click="getExpense">Get</b-button>
      </b-col>-->
    </b-modal>
    <div>
      Post/Get Status: {{getStatus}}
    </div>
  </div>
</template>

<script>
import api from "../../api.js";

export default {
  name: "Expenses",
  data() {
    return {
      messages: [
        {
          message: "",
          error: false
        }
      ],
      getStatus: undefined,
      fields: ["Date", "Expense", "Amount", "Issuer", "Payers", "Description"],
      expense_entries: [
        {
          Date: "5/23/2019",
          Expense: "A big Gary L",
          Amount: 2000,
          Issuer: "Gary Gillespe",
          Payers: { first: "Bob", middle: "P. ", last: "Oop" },
          Description: "Oh no I'm broke!"
        }
      ],

      expense_payer_id: 1,
      expense_issuer_id: 2,
      expense_title: "Rent",
      expense_amount: 10000
    };
  },
  methods: {
    // This should split the costs and submit multiple expenses to the backend
    async addExpense() {
      try {
        // post and wait for response
        let response = await api.expenses.post(
          this.expense_payer_id,
          this.expense_issuer_id,
          this.expense_title,
          this.expense_amount
        );
        console.log(response.data);
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
      // Call get Expense to populate
      this.getExpense();
    },
    async getExpense() {
      try {
        // get Expense
        let response = await api.expenses.get(
          "jsmith@example.com",
          "password123"
          //  this.expense_payer_id // TODO CHANGE THIS TO SEND EMAIL AND PASS
        );
        this.getStatus = response.status;
        // response.data has array of all the expenses TODO

        // add to table
        this.expense_entries.push({
          Date: "5/24/2019",
          Expense: "ExampleEntry",
          Amount: 9000,
          Issuer: "Kevin the God",
          Payers: { first: "A", middle: "B. ", last: "G" },
          Description: "Oh no I'm really broke now!"
        });
      } catch (err) {
        // Error handling
        this.getStatus = "FAILED";
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
    }
  }
};
</script>