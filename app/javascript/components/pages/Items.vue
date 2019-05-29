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
                {{ row.value }}
            </template>

            <template slot="Owner" slot-scope="row">
                {{ row.value.first }} {{ row.value.middle }} {{ row.value.last }}
            </template>

            <template slot="Actions" slot-scope="row">
                <b-button variant="primary">Edit</b-button>
                <b-button v-b-modal="'my_modal_items'" variant="danger" @click="sendInfo(row.item.Name)">Remove</b-button>
            </template>
        </b-table>

        <b-button v-b-modal.modal-1 variant="primary">Add Item</b-button>
        <b-modal id="modal-1" title="Add Item" ok-title="Add">
            <label>Item Name:</label>
            <b-form-input v-model="text" placeholder=""></b-form-input>
            <label>Owner:</label>
            <b-form-input v-model="text" placeholder=""></b-form-input>
        </b-modal>

        <b-modal id='my_modal_items' hide-footer title="Delete Item">
            <p><b>Are you SURE you wish to remove this item?</b></p>
            <p><i>Note: This action can not be undone.</i></p>
            <b-button class="mt-2" variant="info"  @click="hideModal('my_modal_items')">No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger"  @click="toggleModal('my_modal_items',selectedRow)">Yes, I am sure.</b-button>
        </b-modal>

    </div>
</template>

<script>
    import api from '../../api.js';

    export default {
        name: "Items",
        data() {
            return {
                fields: ['Name', 'Owner', 'Actions'],
                items: this.getItems(),
                selectedRow: ''
            };
        },
        methods: {
            sendInvite() {
                // TODO
            },
            async getItems() {
                // let response = await api.document.get('jsmith@example.com', 'password123')
                // console.log(response.data)
                console.log("test")
                return [
                    { Name: "Microwave", Owner: {first: "Bob", middle: "P. ", last: "Oop"}},
                    { Name: "Television", Owner: {first: "Charlie", middle: "M. ", last: "Smith"}}
                ]
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
            },
            hideModal(modal) {
                this.$root.$emit('bv::hide::modal', modal, '#btnShow')
            },
            toggleModal(modal, row) {
                console.log(row)
                this.items = this.getItems()
                this.$root.$emit('bv::toggle::modal', modal, '#btnToggle')
            },
            openWindow(url) {
                window.open(url, "_blank")
            },
            sendInfo(row) {
                this.selectedRow = row
            }
        }
    };
</script>