<template>
  <div>
    <b-jumbotron>
      <template slot="header">Documents</template>
      <b-table
          show-empty
          :busy="tableBusy"
          stacked="md"
          :items="items"
          :fields="fields">
        <div slot="table-busy" class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong>Loading...</strong>
        </div>

        <template slot="Title" slot-scope="row">
          {{ row.item.title }}
        </template>

        <template slot="Filename" slot-scope="row">
          {{ row.item.file_name }}
        </template>

        <template slot="Uploader" slot-scope="row">
          {{ row.item.creator_name }}
        </template>

        <template slot="Actions" slot-scope="row">
          <b-button variant="info" @click="openTab(row.item.url)">Open</b-button>
          <b-button variant="success" :href="row.item.url" download>Download</b-button>
          <b-button v-b-modal="'my_modal_documents'" variant="danger" @click="sendInfo(row.item.id)">Delete</b-button>
        </template>
      </b-table>

      <b-modal id='my_modal_documents' hide-footer title="Delete Document">
        <p><b>Are you SURE you wish to remove this document?</b></p>
        <p><i>Note: This action can not be undone.</i></p>
        <b-button class="mt-2" variant="info" @click="hideModal('my_modal_documents')">No, I am not sure.</b-button>
        <b-button class="mt-2" variant="danger" @click="toggleModal('my_modal_documents',selectedRow)">Yes, I am sure.
        </b-button>
      </b-modal>

      <b-modal id="addModal"
               ref="addModal"
               hide-footer
               @close="resetAddModal"
               title="Add Document">
        <label>Name of Document:</label>
        <b-form-input v-model="title"></b-form-input>
        <b-form-file
            class="my-3"
            v-model="file"
            :state="Boolean(file)"
            :file-name-formatter="truncateFileName"
            placeholder="Choose a file..."
            drop-placeholder="Drop file here..."
        ></b-form-file>

        <b-button variant="secondary"
                  :disabled="file==null||title===''"
                  @click="upload">
        Upload
        </b-button>
        <b-alert class="my-3" variant="danger" :show="uploadError">{{uploadError}}</b-alert>

      </b-modal>

      <b-button v-b-modal.addModal variant="primary">Upload Document</b-button>

    </b-jumbotron>
  </div>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "Documents",
    data() {
      return {
        fields: ['Title', 'Filename', 'Uploader', 'Actions'],
        items: [],
        selectedRow: '',
        tableBusy: false,

        title: undefined,
        file: null,
        uploadError: undefined,
      };
    },
    created(){
      this.getDocuments();
    },
    methods: {
      async getDocuments() {
        this.tableBusy = true;
        let response = await api.document.all(this.$store.state.username,
                                              this.$store.state.password);
        // Only display the apartmentwide documents
        this.items = response.data.filter((x) => x.apartmentwide);
        this.tableBusy = false;
      },

      async postDocument(fileData, fileName, fileSize) {
        // If fileData too large, set error and return
        const MAX_MB = 8;
        if(fileSize/1024/1024 >= MAX_MB){
          this.uploadError = 'File size too large (exceeds ' + MAX_MB + ' MB).';
          return;
        }

        try {
          // Post document and update list
          await api.document.post(
              undefined,
              this.title,
              fileName,
              true,
              fileData,
              this.$store.state.username,
              this.$store.state.password,
          );
          this.getDocuments();

          // Cleanup and reset modal
          this.$refs.addModal.hide();
          this.resetAddModal();
        } catch(err){
          if(err.response){
            this.uploadError = err.response.data.errors[0];
          }
        }
      },

      async deleteDocument(row) {
        await api.document.delete(row, this.$store.state.username, this.$store.state.password);
        this.getDocuments();
      },

      upload() {
        let reader = new FileReader();
        reader.onloadend = () => {
          let binaryString = reader.result;
          let fileData = btoa(binaryString);
          this.postDocument(fileData, this.file.name, this.file.size);
        };
        reader.readAsBinaryString(this.file);
      },

      hideModal(modal) {
        this.$root.$emit('bv::hide::modal', modal, '#btnShow');
      },

      toggleModal(modal, row) {
        this.deleteDocument(row);
        this.$root.$emit('bv::toggle::modal', modal, '#btnToggle');
      },

      sendInfo(row) {
        this.selectedRow = row;
      },

      resetAddModal(){
        this.title = '';
        this.file = undefined;
        this.uploadError = undefined;
      }
    }
  };
</script>
