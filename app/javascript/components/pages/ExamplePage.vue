<template>
  <b-jumbotron header-level="4">
    <template slot="header">
      API Usage Example Page
    </template>

    <b-row>
      <b-col>
        <b-form-input v-model="formText" placeholder="Enter your name" @keyup.enter="postToExample"></b-form-input>
      </b-col>
      <b-col md="auto">
        <b-button @click="postToExample">Post</b-button>
      </b-col>
    </b-row>

    Number of items in the table: {{ messages.length }}

    <b-table :items="messages" :fields="tableFields" outlined></b-table>

  </b-jumbotron>
</template>

<script>
  import api from '../../api.js';

  export default {
    name: "ExamplePage",
    data() {
      return {
        formText: undefined,
        messages: [],
        tableFields: [
          {
            key: 'message',
            sortable: true
          },
          {
            key: 'error',
            sortable: true
          }
        ],
      }
    },
    methods: {
      async postToExample(){
        try {
          // post and wait for response
          let response = await api.example.post(this.formText);
          // add to table
          this.messages.push({
            message: response.data.message,
            error: false
          });
        } catch (err) { // Error handling
          this.messages.push({
            message: err.response.data,
            error: true
          });
          if(err.response){
            switch (err.response.status) {
              case 400: // Bad request
                console.log('Bad request');
                break;
              default: // 500
                console.log('An unknown error occurred.');
                break;
            }
          }
        }

        // clear form after submit
        this.formText = '';
      }
    }
  }
</script>
