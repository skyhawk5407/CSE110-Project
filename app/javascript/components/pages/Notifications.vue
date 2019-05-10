<template>
  <div>
    <b-jumbotron>
      <template slot="header">
        Notifications
      </template>
      <template slot="lead">
		<div style="margin-top: 50px">
			<b-row class="my-1">
				<b-col sm="10">
					<b-form-textarea v-model="text" placeholder="Insert Notification Message Here"></b-form-textarea>
				</b-col>
			</b-row>
		</div>
		<div style="margin-left: 105px; margin-top: 20px">
			<b-button>Send Notification</b-button>
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
