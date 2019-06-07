<template>
  <div>
    <b-jumbotron>
      <template slot="header">Expenses</template>
      <br>
      <h2>
        Total Amount you owe:
        <b-badge variant="info">{{totalOwed}}</b-badge>
      </h2>
      <!-- Top Half of Table: Expenses you owe, can only pay these -->
      <label style="font-weight:bold">Expenses You Owe</label>
      <b-checkbox name="checkbox-1" v-model="filterExpense">Your Unpaid Expenses</b-checkbox>
      <b-table
        responsive
        show-empty
        stacked="md"
        :items="filterExpense ? unpaidExpenses : expense_entries"
        :fields="fields"
      >
        <!-- Data -->
        <template slot="Date" slot-scope="col">{{ col.value }}</template>
        <template slot="Expense" slot-scope="col">{{ col.value }}</template>
        <template slot="Amount" slot-scope="col">{{ col.value }}</template>
        <template slot="Issuer" slot-scope="col">{{ col.value }}</template>
        <template slot="Payers" slot-scope="col">{{ col.value }}</template>
        <template slot="Description" slot-scope="col">{{ col.value }}</template>
        <template slot="Paid" slot-scope="col">{{ paidStatus(col.value)}}</template>
        <!-- Actions -->
        <template slot="Actions" slot-scope="row">
          <!-- Pay Expense Button -->
          <b-button
            v-b-modal.modal-pay
            variant="primary"
            class="btn-sm"
            :disabled="row.item.Paid || row.item.Email != current_user_email"
            @click="sendInfo(row.item)"
          >Pay</b-button>
          <!-- PAY DONT LET IT DISPLAY IN THE ROW IF FALSE -->
        </template>
      </b-table>
      <!-- Bottom Half of Table: Expenses you issued, you can delete these -->
      <label style="font-weight:bold">Expenses You Issued</label>
      <b-checkbox name="checkbox-1" v-model="filterExpenseIssued">Your Unpaid Expenses Issued</b-checkbox>
      <b-table
        responsive
        show-empty
        stacked="md"
        :items="filterExpenseIssued ? unpaidExpensesIssued : issued_expense_entries"
        :fields="fields"
      >
        <template slot="Date" slot-scope="col">{{ col.value }}</template>
        <template slot="Expense" slot-scope="col">{{ col.value }}</template>
        <template slot="Amount" slot-scope="col">{{ col.value }}</template>
        <template slot="Issuer" slot-scope="col">{{ col.value }}</template>
        <template slot="Payers" slot-scope="col">{{ col.value }}</template>
        <template slot="Description" slot-scope="col">{{ col.value }}</template>
        <template slot="Paid" slot-scope="col">{{ paidStatus(col.value)}}</template>
        <!-- Actions -->
        <template slot="Actions" slot-scope="row">
          <b-button
            v-b-modal.modal-remove
            variant="danger"
            class="btn-sm"
            @click="sendInfo(row.item)"
          >Remove</b-button>
        </template>
      </b-table>
      <!-- Add Expense Button at Bottom -->
      <b-button v-b-modal.modal-add variant="primary">Add Expense</b-button>

      <!-- Modals that respond to buttons on table -->
      <!-- Pay Expense Modal -->
      <b-modal id="modal-pay" hide-footer title="Pay Expense" no-stacking>
        <p>
          <b>Are you SURE you wish to pay this expense?</b>
          <br>
          <br>
          <i>Note: This action can not be undone.</i>
        </p>
        <b-button class="mt-2" variant="danger" @click="payExp(selected_row)">Yes, I am sure.</b-button>
        <b-button class="mt-2" variant="info" @click="$bvModal.hide('modal-pay')">No, I am not sure.</b-button>
      </b-modal>
      <!-- Remove Expense Modal -->
      <b-modal id="modal-remove" hide-footer title="Remove Expense" no-stacking>
        <p>
          <b>Are you SURE you wish to remove this expense?</b>
          <br>
          <br>
          <i>Note: This action can not be undone.</i>
        </p>
        <b-button class="mt-2" variant="danger" @click="removeExp(selected_row)">Yes, I am sure.</b-button>
        <b-button
          class="mt-2"
          variant="info"
          @click="$bvModal.hide('modal-remove')"
        >No, I am not sure.</b-button>
      </b-modal>
      <!-- Add Expense Modal -->
      <b-modal id="modal-add" hide-footer title="Add Expense">
        <!-- Expense Fields -->
        <label>Name of Expense:</label>
        <b-form-input v-model="expense_title" placeholder="Name"></b-form-input>
        <label>Amount:</label>
        <b-input-group prepend="$">
          <b-form-input
            v-model="expense_amount"
            placeholder="0.00"
            min="0"
            step="0.5"
            type="number"
          ></b-form-input>
        </b-input-group>
        <label>Description:</label>
        <b-form-textarea v-model="expense_description" rows="3" placeholder="Description"></b-form-textarea>
        <label>Select Payer(s):</label>
        <!-- Renders Checkboxes based on whose in the apartment. Updates the payer_list -->
        <div v-for="user in apartment_mates" :key="user.id">
          <div v-if="user.id != current_user_id">
            <label>{{user.display_name}}</label>
            <input type="checkbox" v-model="payer_list" :value="user">
            <!-- <b-form-input v-model="" placeholder=""></b-form-input> -->
          </div>
        </div>
        <b-alert class="my-3" variant="danger" :show="uploadError">{{uploadError}}</b-alert>
        <!-- Options -->
        <b-button class="mt-2" variant="info" @click="addExpense">Add Expense</b-button>
        <b-button
          class="mt-2"
          variant="danger"
          @click="$bvModal.hide('modal-add'); resetForm();"
        >Cancel</b-button>
      </b-modal>
    </b-jumbotron>
  </div>
</template>

<script>
import api from "../../api.js";
import moment from "moment";
import Dinero from "dinero.js";

export default {
  name: "Expenses",
  data() {
    return {
      fields: [
        "Date",
        "Expense",
        "Amount",
        "Issuer",
        "Payers",
        "Description",
        "Paid",
        "Actions"
      ],
      // Current data for each apartment member
      apartment_mates: [],
      // Array for holding who is going to pay your expense
      payer_list: [],

      // Expense Sorting and Display
      expense_entries: [],
      filterExpense: false,
      issued_expense_entries: [],
      filterExpenseIssued: false,
      selected_row: "",

      // Current user Info
      current_user_email: this.$store.state.username,
      current_user_password: this.$store.state.password,
      current_user_id: null,

      // Fields for Expense input
      uploadError: undefined,
      expense_title: undefined,
      expense_description: undefined,
      expense_paid: false,
      expense_amount: undefined
    };
  },
  created() {
    this.extractMates();
    this.getAllExpenses();
  },
  computed: {
    totalOwed() {
      var sum = 0;
      var i = 0;
      // console.log(this.expense_entries);
      for (i in this.expense_entries) {
        if (
          this.current_user_email == this.expense_entries[i].Email &&
          !this.expense_entries[i].Paid
        )
          sum += this.expense_entries[i].AmountInt;
      }
      return this.convertCurrency(sum).toFormat();
    },
    unpaidExpenses() {
      return this.expense_entries.filter(
        x => !x.Paid && x.Email == this.current_user_email
      );
    },
    unpaidExpensesIssued() {
      return this.issued_expense_entries.filter(x => !x.Paid);
    }
  },
  methods: {
    // Helper Functions
    resetForm() {
      this.expense_title = undefined;
      this.expense_description = undefined;
      this.expense_paid = false;
      this.expense_amount = undefined;
      this.payer_list = [];
    },
    paidStatus(isPaid) {
      if (isPaid) {
        return "Yes";
      } else {
        return "No";
      }
    },
    async extractMates() {
      let response = await api.getApt.get(
        this.$store.state.username,
        this.$store.state.password
      );
      var mate_list = response.data.users;
      // console.log(response.data.users);
      for (var i = 0; i < mate_list.length; i++) {
        var apt_mate = mate_list[i];
        if (apt_mate.email == this.$store.state.username) {
          this.current_user_id = apt_mate.id;
        }
        this.apartment_mates.push({
          id: apt_mate.id,
          display_name: apt_mate.display_name,
          email: apt_mate.email
        });
      }
    },
    convertCurrency(cents) {
      return Dinero({ amount: Math.round(cents) });
    },
    async convertoCents(amount) {
      return Math.floor(amount * 100);
    },
    sendInfo(row) {
      this.selected_row = row;
    },
    // Expense Handling
    async payExp(row) {
      var amount = 1;
      var index = this.expense_entries.indexOf(row);
      var expense_id = this.expense_entries[index].Id;
      var paid = this.expense_entries[index].Paid;
      if (paid == false) {
        let response = await api.expenses.pay(
          expense_id,
          !paid,
          this.current_user_email,
          this.current_user_password
        );
        this.expense_entries[index].Paid = !paid;
      }
      this.$bvModal.hide("modal-pay");
    },
    async removeExp(row) {
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
    async addExpense() {
      var success = true;
      var length = this.payer_list.length;
      if (this.payer_list.length == 0) {
        this.uploadError = "Must select at least 1 payer";
        return;
      }
      if (this.expense_amount == undefined) {
        this.uploadError = "Must specify an expense amount";
        return;
      }
      // Current functionality: submits equal expenses for all people selected
      for (const item of this.payer_list) {
        var expense_payer_id = item.id;
        var expense_amount = this.expense_amount;
        try {
          // post and wait for response
          let response = await api.expenses.post(
            expense_payer_id,
            this.current_user_id,
            this.expense_title,
            this.expense_description,
            await this.convertoCents(expense_amount),
            this.current_user_email,
            this.current_user_password,
            false
          );
        } catch (err) {
          // console.log(err);
          success = false;
          if (err.response) {
            this.uploadError = err.response.data.errors[0];
          }
        }
      }
      // Clear Form and close modal if success
      if (success) {
        this.resetForm();
        this.$bvModal.hide("modal-add");
        this.updateExpenses(length);
      }
    },
    async updateExpenses(length) {
      let response = await api.expenses.get(
        this.current_user_email,
        this.current_user_password
      );
      var transactions = response.data;
      var lastIdx = transactions.length;
      var j = 0;
      for (j = lastIdx - length; j < lastIdx; j++) {
        var entry = transactions[j];
        var load = {
          Id: entry.id,
          Date: moment(entry.created_at).format("MM/DD/YYYY"),
          Expense: entry.title,
          Amount: this.convertCurrency(entry.amount).toFormat(),
          Issuer: entry.issuer.display_name,
          Payers: entry.payer.display_name,
          Description: entry.description,
          Paid: entry.paid,
          Email: entry.payer.email,
          AmountInt: entry.amount
        };
        this.issued_expense_entries.push(load);
      }
    },
    async getAllExpenses(updateAll, length) {
      let response = await api.expenses.get(
        this.current_user_email,
        this.current_user_password
      );
      var transactions = response.data;
      // console.log(transactions);
      var i = 0;
      for (i in transactions) {
        var entry = transactions[i];
        // console.log(entry);
        var load = {
          Id: entry.id,
          Date: moment(entry.created_at).format("MM/DD/YYYY"),
          Expense: entry.title,
          Amount: this.convertCurrency(entry.amount).toFormat(),
          Issuer: entry.issuer.display_name,
          Payers: entry.payer.display_name,
          Description: entry.description,
          Paid: entry.paid,
          Email: entry.payer.email,
          AmountInt: entry.amount
        };
        if (entry.issuer.id == this.current_user_id) {
          this.issued_expense_entries.push(load);
        } else {
          this.expense_entries.push(load);
        }
      }
    }
  }
};
</script>