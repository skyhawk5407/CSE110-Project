<template>
  <div>
    <b-jumbotron>
      <template slot="header">Expenses</template>
      <label>Expenses Owed</label>
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
          <b-button v-b-modal.modal-pay variant="primary" class="btn-sm">Pay</b-button>
          <b-modal id="modal-pay" hide-footer title="Pay Expense" no-stacking>
            <p>
              <b>Do you want to pay for this expense?</b>
            </p>
            <b-button class="mt-2" variant="info" @click="$bvModal.hide('modal-pay')">Pay expense</b-button>
            <b-button class="mt-2" variant="danger" @click="$bvModal.hide('modal-pay')">Cancel</b-button>
          </b-modal>
          <!-- Remove Expense Modal and Button-->
          <!-- <b-button v-b-modal.modal-remove variant="danger" class="btn-sm">Remove</b-button>
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
          </b-modal> -->
        </template>
      </b-table>
      <label>Expenses Issued</label>
      <b-table show-empty stacked="md" :items="issued_expense_entries" :fields="fields">
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
          <!-- Pay Expense Indicator -->
          <!-- <b-button v-b-modal.modal-pay variant="primary" class="btn-sm">Pay Me</b-button>
          <b-modal id="modal-pay" hide-footer title="Pay Expense" no-stacking>
            <p>
              <b>Do you want to pay for this expense?</b>
            </p>
            <b-button class="mt-2" variant="info" @click="$bvModal.hide('modal-pay')">Pay expense</b-button>
            <b-button class="mt-2" variant="danger" @click="$bvModal.hide('modal-pay')">Cancel</b-button>
          </b-modal> -->
          <!-- Remove Expense Modal     and Button -->
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
        <b-form-input v-model="expense_title" placeholder="Name"></b-form-input>
        <label>Amount:</label>
        <b-form-input v-model="expense_amount" placeholder="$0.00"></b-form-input>
        <label>Description:</label>
        <b-form-textarea v-model="expense_description" rows="3" placeholder="Description"></b-form-textarea>
        <label>Payer:</label>
        <b-form-input v-model="expense_payer_id" placeholder="Payer"></b-form-input>
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
      apartment_mates: [],
      expense_entries: [],
      issued_expense_entries: [],

      current_user_email: this.$store.state.username,
      current_user_password: this.$store.state.password,
      expense_payer_id: null,
      expense_issuer_id: null,
      expense_title: undefined,
      expense_description: undefined,
      expense_amount: null
    };
  },
  created() {
    this.extractMates();
  },
  methods: {
    async extractMates() {
      let response = await api.getApt.get(
        this.$store.state.username,
        this.$store.state.password
      );
      var mate_list = response.data.users;
      var apartment_mates = [];
      for (var i = 0; i < mate_list.length; i++) {
        var apt_mate = mate_list[i];
        if (apt_mate.email == this.$store.state.username) {
          this.expense_issuer_id = apt_mate.id;
        }
        apartment_mates.push({
          id: apt_mate.id,
          display_name: apt_mate.display_name
        });
      }

      this.getAllExpenses();
    },
    async convertToCurrency(value) {
      var currency = "";
      var dollars = int(value / 100);
      var cents = value - dollar * 100;
      currency = "$" + String(dollars) + "." + String(cents);
      return currency;
    },
    async removeExp(row) {
        console.log(row);
      var amount = 1;
      var index = this.issued_expense_entries.indexOf(row);
      var expense_id = this.issued_expense_entries[index].Id;
      let response = await api.expenses.delete(
        expense_id,
        this.current_user_email,
        this.current_user_password
      );
      this.issued_expense_entries.splice(index, amount);
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
        // Call get Expense to populate
        this.getExpense();
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
        this.issued_expense_entries.push({
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

      var i = 0;
      for (i in transactions) {
        var entry = transactions[i];
        // console.log(entry.id);
        // add to table
        var load = {
          Id: entry.id,
          Date: moment(entry.created_at).format("MM/DD/YYYY"),
          Expense: entry.title,
          Amount: entry.amount,
          Issuer: entry.issuer.display_name,
          Payers: entry.payer.display_name,
          Description: entry.description
        };
        if (entry.issuer.id == this.expense_issuer_id) {
          this.issued_expense_entries.push(load);
        } else {
          this.expense_entries.push(load);
        }
      }
    }
  }
};
</script>