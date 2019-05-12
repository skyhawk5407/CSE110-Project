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
            <template slot="Name" slot-scope="row">
                {{ row.value.first }} {{ row.value.middle }} {{ row.value.last }}
            </template>

            <template slot="Email" slot-scope="row">
                {{ row.value }}
            </template>

            <template slot="Actions" slot-scope="row">
                <b-button v-b-modal="'modal-2'" variant="danger">Delete</b-button>
                <b-modal id="modal-2" hide-footer title="Remove Apartment Mate">
                    <p><b>Are you SURE you wish to remove this apartment mate?</b></p>
                    <p><i>Note: This action can not be undone.</i></p>
                    <b-button class="mt-2" variant="info">No, I am not sure.</b-button>
                    <b-button class="mt-2" variant="danger">Yes, I am sure.</b-button>
                </b-modal>
            </template>
        </b-table>
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
                fields: ['Name', 'Email', 'Actions'],
                items: [
                    { Name: {first: "Bob", middle: "P. ", last: "Oop"}, Email: "bobp@ucsd.edu"},
                    { Name: {first: "Charlie", middle: "M. ", last: "Smith"}, Email: "charlies@ucsd.edu"}
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