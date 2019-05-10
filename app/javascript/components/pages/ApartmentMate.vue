<template>
  <div>
    <!-- TODO: display apartment mate info -->

    <!-- TODO: Add on click handlers into a form -->
    <!-- TODO: Allow form to be reset each time + popup email sent! -->
    <b-button v-b-modal.modal-1 variant="primary">Invite Apartment Mate</b-button>

    <!-- Modal Component 1-->
    <b-modal id="modal-1" centered title="Send E-mail">
      <!-- Form for sending emails -->
      <form ref="form" @submit.stop.prevent="handleSubmit">
        <b-form-group
          :state="nameState"
          label="Email"
          label-for="Email-input"
          invalid-feedback="Email is required"
        >
          <b-form-input id="Email-input" v-model="name" :state="nameState" required></b-form-input>
        </b-form-group>
      </form>

      <div slot="modal-footer" slot-scope="{ cancel }" >
        <b-button
          class="float-right"
          variant="outline-warning"
          block
          @click="sendInvite"
        >Send Invite</b-button>
        <b-button
          class="float-right"
          size="sm"
          variant="outline-danger"
          block
          @click="cancel()"
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
      name: "",
      show: true,
      nameState: null,
      submittedNames: []
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
