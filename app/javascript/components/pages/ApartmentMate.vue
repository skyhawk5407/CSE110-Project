<template>
  <div>
    <b-jumbotron>
      <template slot="header">
				Apartment Mates
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
        <template
          slot="Name"
          slot-scope="row"
        >{{ row.item.display_name }}</template>

        <template slot="Email" slot-scope="row">{{ row.item.email }}</template>

        <template slot="Actions" slot-scope="row">
          <b-button v-b-modal="'modal-2'" variant="danger" @click="sendInfo(row.item.id)" :disabled="disable(row.item.email)">Remove Apartment Mate</b-button>
          <b-modal id="modal-2" hide-footer title="Remove Apartment Mate">
            <p>
              <b>Are you SURE you wish to remove this apartment mate?</b>
            </p>
            <p>
              <i>Note: This action can not be undone.</i>
            </p>
            <b-button class="mt-2" variant="info" @click="hideModal('modal-2')">No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger" @click="toggleModal('modal-2', selectedRow)">Yes, I am sure.</b-button>
          </b-modal>
        </template>
      </b-table>

      <div>
        <!-- BELOW IS DEBUGGING TO SHOW IF EMAIL WAS SENT OR NOT -->
        <!-- <div class="mt-3">
        Submitted Names:
        <div v-if="submittedEmails.length === 0">--</div>
        <ul v-else class="mb-0 pl-3">
          <li v-for="email in submittedEmails">{{ status }} {{ email }}</li>
        </ul>
        </div>-->
        <b-button @click="$bvModal.show('modal-email')">Invite Apartment Mate</b-button>

        <b-button v-b-modal="'modal-1'" variant="danger" class="float-right">Leave Apartment</b-button>
        <b-modal id="modal-1" hide-footer title="Leave Apartment" ref="leave_Modal">
            <p><b>Are you SURE you wish to leave your apartment?</b></p>
            <p><i>Note: This action can not be undone.</i></p>
            <b-button class="mt-2" variant="info" @click="hideModal('modal-1')">No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger" @click="leaveApartment">Yes, I am sure.</b-button>
        </b-modal>

        <!-- Modal Component 1-->
        <b-modal id="modal-email" centered title="Send E-mail" ref="Email_Modal" hide-header-close>
          <!-- Form for sending emails -->
          <form ref="form" @handleSendInvite.stop.prevent="handleSendInvite">
            <b-form-group
              :state="emailState"
              label="Email"
              label-for="Email-input"
              invalid-feedback="Valid Email is required"
            >
              <b-form-input id="Email-input" v-model="email" :state="emailState" required></b-form-input>
            </b-form-group>
          </form>
          <!-- We pass the name cancel as props to footer -->
          <div slot="modal-footer">
            <b-button
              class="float-right"
              variant="outline-warning"
              block
              @click="handleSendInvite"
            >Send Invite</b-button>
            <b-button
              class="float-right"
              size="sm"
              variant="outline-danger"
              block
              @click="cancel"
            >Cancel</b-button>
          </div>
        </b-modal>


      </div>
    </b-jumbotron>
  </div>
</template>

<script>

import api from '../../api.js';

export default {
  name: "ApartmentMate",
  data() {
    return {
      email: "",
      emailState: null,
      status: null,
      submittedEmails: [],
      // ADDED ^^^
      fields: ["Name", "Email", "Actions"],
      items: [],
      selectedRow: '',
    };
  },
  created(){
      this.getApartment();
  },
  methods: {

      async removeMate(row){
        try {
          // post and wait for response
          let response = await api.removeMate.post(row, this.$store.state.username, this.$store.state.password);
          console.log(response.data);
        } catch (err) {
      // Error handling
          console.log(err);
          if(err.response){
            switch (err.response.status) {
              case 401:
                console.log(err.response.data);
                break;
              default:
                console.log('An unknown error occurred.');
                break;
            }
          }
        }
        this.getApartment();
      },

      async getApartment() {
        let response = await api.getApt.get(this.$store.state.username,
                                              this.$store.state.password);
        // Only display the apartmentwide documents
        this.items = response.data.users;
      },

      async invite(){
        try {
          // post and wait for response
          let response = await api.invite.post(this.email, this.$store.state.username, this.$store.state.password);
          console.log(response.data);
        } catch (err) {
      // Error handling
          console.log(err);
          if(err.response){
            switch (err.response.status) {
              case 400:
                console.log(err.response.data);
                break;
              case 401:
                console.log(err.response.data);
                break;
              default:
                console.log('An unknown error occurred.');
                break;
            }
          }
        }
      },

      async leaveApartment() {
        try {
          let response = await api.leave.post(this.$store.state.username, this.$store.state.password);
          this.$refs.leave_Modal.hide();
          this.$router.push({path: 'Dashboardi'});

        } catch (err) {
          if(err.response) {
            switch(err.response.status) {
              case 400:
                console.log(err.reponse.data);
                break;
              default:
                console.log('An unknown error occurred.');
                break;
            }
          }
        }
      },

      hideModal(modal) {
        this.$root.$emit('bv::hide::modal', modal, '#btnShow');
      },

      toggleModal(modal, row) {
        this.removeMate(row);
        this.$root.$emit('bv::toggle::modal', modal, '#btnToggle');
      },

      sendInfo(row) {
        this.selectedRow = row;
      },

      disable(email) {
        if(email === this.$store.state.username) {
          return true;
        }
        else {
          return false;
        }
      },

      cancel() {
        this.$nextTick(() => {
          this.$refs.Email_Modal.hide();
        });
        this.resetForm();
      },
      handleSendInvite() {
        // Exit when the form isn't valid
        if (!this.checkFormValidity()) {
          return;
        }
        this.invite();
        this.submittedEmails.push(this.email);
        this.status = "Invite Sent to: ";
        // NOtify user that invite was made and backend send
        this.$nextTick(() => {
          this.$refs.Email_Modal.hide();
          this.resetForm();
        });
        this.$emit(alert("Invite Sent to " + this.email));
      },
      resetForm() {
        // Reset our form values
        this.email = "";
        this.emailState = null;
        this.status = null;
      },
      checkFormValidity() {
        if (
          this.submittedEmails == null ||
          this.submittedEmails.indexOf(this.email) != -1 ||
          !this.$refs.form.checkValidity()
        ) {
          this.emailState = "invalid";
          return false;
        }
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        const valid = re.test(this.email);
        this.emailState = valid ? "valid" : "invalid";
        return valid;
      }
  }
};
</script>
