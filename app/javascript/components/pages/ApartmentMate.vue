<template>
  <div>
    <!-- TODO: display apartment mate info -->
    <!-- TODO: Allow form to be reset each time + popup email sent! -->
    <!-- <div class="mt-3">
      Apartment: {{showApartment}}
      <div v-if="apartmentMembers.length === 0">--</div>
      <ul v-else class="mb-0 pl-3">
        <li v-for-key="member in apartmentMembers">{ {{ member }}</li>
      </ul>
    </div> -->

    <div class="mt-3">
      Submitted Names:
      <div v-if="submittedEmails.length === 0">--</div>
      <ul v-else class="mb-0 pl-3">
        <li v-for="email in submittedEmails">{{ status }} {{ email }}</li>
      </ul>
    </div>

    <b-button @click="$bvModal.show('modal-email')">Invite Apartment Mate</b-button>
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
</template>

<script>
export default {
  name: "ApartmentMate",
  data() {
    return {
      email: "",
      emailState: null,
      status: null,
      submittedEmails: [],
      apartmentMembers: []
    };
  },
  methods: {
    showApartment() {
      // TODO SHOW FROM BACKEND
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
      this.submittedEmails.push(this.email);
      this.status = "Invite Sent to: ";
      // NOtify user that invite was made and backend send
      this.$nextTick(() => {
        this.$refs.Email_Modal.hide();
      });
      this.resetForm();
    },
    resetForm() {
      // Reset our form values
      this.email = "";
      this.emailState = null;
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
