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
                    <p><b>Are you SURE you wish to remove this expense?</b></p>
                    <p><i>Note: This action can not be undone.</i></p>
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
            <b-form-input v-model="text" placeholder=""></b-form-input>
            <label>Amount:</label>
            <b-form-input v-model="text" placeholder=""></b-form-input>
            <label>Description:</label>
            <b-form-textarea v-model="text" rows="3" placeholder=""></b-form-textarea>
        </b-modal>
    </div>
</template>

<script>
    export default {
        name: "Splitter",
        data() {
            return {
                fields: ['Name', 'Amount', 'Description', 'Actions'],
                items: [
                    { Name: "Monthly Rent", Amount: '$700', Description: 'Venmo id: bob-93', Email: "bobp@ucsd.edu"},
                    { Name: "Utilities", Amount: '$25', Description: 'Venmo id: smith-68', Email: "charlies@ucsd.edu"}
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