<template>
  <div>
    <b-jumbotron>
      <template slot="header">Expenses</template>
      <b-table show-empty stacked="md" :items="expense_entries" :fields="fields">
        <!-- Props to b-table to add later TODO -->
        <!-- :filter="filter"
      :sort-by.sync="sortBy"
      :sort-desc.sync="sortDesc"
      :sort-direction="sortDirection"
        @filtered="onFiltered"-->
        <!-- Data -->
        <template slot="Date" slot-scope="col">{{ col.value }}</template>
        <template slot="Expense" slot-scope="col">{{ col.value }}</template>
        <template slot="Amount" slot-scope="col">{{ col.value }}</template>
        <template slot="Issuer" slot-scope="col">{{ col.value }}</template>
        <template slot="Payers" slot-scope="col">{{ col.value }}</template>
        <template slot="Description" slot-scope="col">{{ col.value }}</template>
        <!-- Actions -->
        <template slot="Actions" slot-scope="row">
          <!-- Pay Expense Modal and Button -->
          <b-button v-b-modal.modal-pay variant="primary" class="btn-sm">Pay Me</b-button>
          <b-modal id="modal-pay" hide-footer title="Pay Expense" no-stacking>
            <p>
              <b>Do you want to pay for this expense?</b>
            </p>
            <b-button class="mt-2" variant="info" @click="$bvModal.hide('modal-pay')">Pay expense</b-button>
            <b-button class="mt-2" variant="danger" @click="$bvModal.hide('modal-pay')">Cancel</b-button>
          </b-modal>
          <!-- Remove Expense Modal and Button-->
          <b-button v-b-modal.modal-remove variant="danger" class="btn-sm">Remove</b-button>
          <b-modal id="modal-remove" hide-footer title="Remove Expense" no-stacking>
            <p>
              <b>Are you SURE you wish to remove this expense?</b>
              <br>
              <br>
              <i>Note: This action can not be undone.</i>
            </p>
            <b-button
              class="mt-2"
              variant="info"
              @click="$bvModal.hide('modal-remove')"
            >No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger" @click="removeExp(row.item)">Yes, I am sure.</b-button>
          </b-modal>
        </template>
      </b-table>
      <!-- Add Expense Modal and Button -->
      <b-button v-b-modal.modal-add variant="primary">Add Expense</b-button>
      <b-modal id="modal-add" hide-footer title="Add Expense">
        <!-- Expense Fields -->
        <label>Name of Expense:</label>
        <b-form-input v-model="expense_title"></b-form-input>
        <label>Amount:</label>
        <b-form-input v-model="expense_amount"></b-form-input>
        <label>Description:</label>
        <b-form-textarea v-model="expense_description" rows="3"></b-form-textarea>
        <label>Payer:</label>
        <b-form-input v-model="expense_payer_id"></b-form-input>
        <!-- Options -->
        <b-button class="mt-2" variant="info" @click="addExpense">Add Expense</b-button>
        <b-button class="mt-2" variant="danger" @click="$bvModal.hide('modal-add')">Cancel</b-button>
      </b-modal>
    </b-jumbotron>
  </div>
</template>

<script>
import api from "../../api.js";
import moment from "moment";

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
      fields: [
        "Date",
        "Expense",
        "Amount",
        "Issuer",
        "Payers",
        "Description",
        "Actions"
      ],
      expense_entries: [],

      current_user_email: this.$store.state.username,
      current_user_password: this.$store.state.password,
      expense_payer_id: 1,
      expense_issuer_id: 1,
      expense_title: "Rent",
      expense_description: "Now I am realy realy really broke!",
      expense_amount: 10000
    };
  },
  created() {
    this.getAllExpenses();
  },
  methods: {
    async removeExp(row) {
      var amount = 1;
      var index = this.expense_entries.indexOf(row);
      let response = await api.expenses.delete(
        this.expense_entries[index].Id,
        this.current_user_email,
        this.current_user_password
      );
      this.expense_entries.splice(index, amount);
      this.$bvModal.hide("modal-remove");
    },
    // This should split the costs and submit multiple expenses to the backend TODO FIX THIS TO UPDATED EXPENSE ENTRIES
    async addExpense() {
      try {
        // post and wait for response
        let response = await api.expenses.post(
          this.expense_payer_id,
          this.expense_issuer_id,
          this.expense_title,
          this.expense_description,
          this.expense_amount,
          this.current_user_email,
          this.current_user_password
        );
        // console.log(response.data);
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
      // Call get Expense to populate
      this.getExpense();
      this.$bvModal.hide("modal-add");
    },
    async getExpense() {
      try {
        // get Expense
        let response = await api.expenses.get(
          this.current_user_email,
          this.current_user_password
        );

        var transactions = response.data;
        var lastTransactionId = transactions.length - 1;
        console.log(response);
        // This data contains all the data for the last transaction
        var lastTransactionEntry = transactions.find(
          function findLastTransaction(element, index, array) {
            var lastTransactionId = array.length - 1;
            return element == lastTransactionId || index == lastTransactionId;
          },
          lastTransactionId
        );
        console.log(lastTransactionEntry);
        // add to table
        this.expense_entries.push({
          Id: lastTransactionEntry.id,
          Date: moment(lastTransactionEntry.created_at).format("MM/DD/YYYY"),
          Expense: lastTransactionEntry.title,
          Amount: lastTransactionEntry.amount,
          Issuer: lastTransactionEntry.issuer.display_name,
          Payers: lastTransactionEntry.payer.display_name,
          Description: lastTransactionEntry.description
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
        console.log(err);
      }

      // clear form after submit
      this.formText = "";
    },
    async getAllExpenses() {
      let response = await api.expenses.get(
        this.current_user_email,
        this.current_user_password
      );
      var transactions = response.data;
      console.log(transactions);
      // TODO CAN YOU get the issuer ID and set it?
      //      expense_issuer_id: 1, get issuer and set it.. payer example id was 2
      // Iterate through each transaction and push...
      // This data contains all the data for the last transaction
      // var lastTransactionEntry = transactions.find(
      //   function findissuerId(element, index, array) {
      //     var currentUser = thus.current_user_email;
      //     return element == currentUser || index == lastTransactionId;
      //   },
      //   lastTransactionId
      // );
      var i = 0;
      for (i in transactions) {
        var entry = transactions[i];
        // add to table
        this.expense_entries.push({
          Id: entry.Id,
          Date: moment(entry.created_at).format("MM/DD/YYYY"),
          Expense: entry.title,
          Amount: entry.amount,
          Issuer: entry.issuer.display_name,
          Payers: entry.payer.display_name,
          Description: entry.description
        });
      }
    }
  }
};
</script>