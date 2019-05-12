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
                            <b-form-input v-model="text" placeholder="Subject"></b-form-input>
                            <b-form-textarea v-model="text" placeholder="Message" rows="4"></b-form-textarea>
                        </b-col>
                    </b-row>
                </div>
                <div style="margin-top: 20px">
                    <b-button variant="info">Send Notification</b-button>
                </div>
            </template>
        </b-jumbotron>
    </div>
</template>

<script>
    export default {
        name: "Notifications"
    }
</script>