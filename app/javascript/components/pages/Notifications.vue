<template>
    <div>
        <b-jumbotron>
            <template slot="header">
                Notifications
            </template>
            <template slot="lead">
                <div style="margin-top: 20px">
                    <b-row class="my-1">
                        <b-col>
                            <b-form-input v-model="title" placeholder="Subject"></b-form-input>
                            <b-form-textarea v-model="message" placeholder="Message" rows="4"></b-form-textarea>
                        </b-col>
                    </b-row>
                </div>
                <div style="margin-top: 20px">
                    <b-button variant="info" @click="postToNotification">Send Notification</b-button>
                </div>
            </template>
        </b-jumbotron>
    </div>
</template>

<script>
  import api from '../../api.js';
    export default {
        name: "Notifications",
        data() {
        return {
            title: "",
            message: "",
        }
        },
        methods: {
            async postToNotification(){
                try {
                // post and wait for response
                console.log(this.title);
                console.log(this.message);
                let response = await api.notification.post(this.title, this.message, 
                "jsmith@example.com", "password123");


                console.log(response.status);
                console.log(response.data);

                } catch (err) { // Error handling
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
                this.title = "";
                this.message = "";

            }

        }
    }
</script>