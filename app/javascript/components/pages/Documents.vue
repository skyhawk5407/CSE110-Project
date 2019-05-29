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
                {{ row.item.filename }}
            </template>

            <template slot="Title" slot-scope="row">
                {{ row.item.title }}
                <!--{{ row.value.first }} {{ row.value.middle }} {{ row.value.last }}-->
            </template>

            <template slot="Actions" slot-scope="row">
                <b-button variant="success" @click="openWindow(row.item.url)">Download</b-button>
                <b-button v-b-modal="'my_modal_documents'" variant="danger" @click="sendInfo(row.item.filename)">Delete</b-button>
            </template>
        </b-table>

        <b-modal id='my_modal_documents' hide-footer title="Delete Document">
            <p><b>Are you SURE you wish to remove this document?</b></p>
            <p><i>Note: This action can not be undone.</i></p>
            <b-button class="mt-2" variant="info"  @click="hideModal('my_modal_documents')">No, I am not sure.</b-button>
            <b-button class="mt-2" variant="danger"  @click="toggleModal('my_modal_documents',selectedRow)">Yes, I am sure.</b-button>
        </b-modal>

        <input type="file" ref="file" style="display: none" @change="onFileChange" ><br>
        <b-button v-b-modal.modal-1 variant="primary" @click="$refs.file.click()">Upload Document</b-button>


    </div>
</template>

<script>
    import api from '../../api.js';

    export default {
        name: "Documents",
        data() {
            return {
                fields: ['Name', 'Title', 'Actions'],
                items: this.getDocuments,
                selectedRow: ''

            };
        },
        methods: {
            sendInvite() {
                // TODO
            },

            async getDocuments() {
                // Make the Api call here in order to update the data.
                // let response = api.document.post(221132332414, "docs1", "docs1.txt", false, 2342374829374982374892374893274982739847238947923874892374982374893272389472398472389);
                let response = await api.document.get('jsmith@example.com', 'password123')
                console.log(response.data)
                return response.data
                // return [{ Name: response.data[0]['filename'], Creator: {first: "Bob", middle: "P. ", last: "Oop"}, URL: response.data[0]['url']}]
                // return item
                // console.log(api.document.get(this.login_email_text, this.login_password_text));
                // return [{ Name: "Rules.docx", Creator: {first: "Bob", middle: "P. ", last: "Oop"}, URL: "https://jacobsschool.ucsd.edu/faculty/faculty_bios/photos/300.jpg"},
                //     { Name: "Lease_Agreement.pdf", Creator: {first: "Charlie", middle: "M. ", last: "Smith"},  URL: "https://jacobsschool.ucsd.edu/faculty/faculty_bios/photos/300.jpg"}]
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
            onFileChange(e) {
                const file = e.target.files[0];
                var encoded = btoa(file)
                var input = event.target;
                // this.url = URL.createObjectURL(file);
                var reader = new FileReader();

                reader.onload = function(){
                    var text = reader.result;
                    var encoded = btoa(text);
                };
                reader.readAsText(file);
            },
            hideModal(modal) {
                this.$root.$emit('bv::hide::modal', modal, '#btnShow')
            },
            toggleModal(modal, row) {
                this.items = this.getDocuments()
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