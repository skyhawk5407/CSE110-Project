<template>
  <div>
	  <b-card no-body>
		  <b-tabs card>
			  <b-tab title="Apartment Mates" active>
				  <ApartmentMate></ApartmentMate>
			  </b-tab>
			  <b-tab title="Documents">
                  <Documents></Documents>
			  </b-tab>
			  <b-tab title="Items">
                  <Items></Items>
			  </b-tab>
			  <b-tab title="Rules">
                  <Rules></Rules>
			  </b-tab>
			  <b-tab title="Rent Splitter">
                  <Splitter></Splitter>
			  </b-tab>
			  <b-tab title="Notifications">
                  <Notifications></Notifications>
			  </b-tab>
              <b-tab title="Leave Apartment">
                  <b-button v-b-modal="'modal-1'" variant="danger">Leave Apartment</b-button>
                  <b-modal id="modal-1" hide-footer title="Leave Apartment">
                      <p><b>Are you SURE you wish to leave your apartment?</b></p>
                      <p><i>Note: This action can not be undone.</i></p>
                      <b-button class="mt-2" variant="info">No, I am not sure.</b-button>
                      <b-button class="mt-2" variant="danger">Yes, I am sure.</b-button>
                  </b-modal>
              </b-tab>
		  </b-tabs>
	  </b-card>
  </div>
</template>

<script>
	import ApartmentMate from './ApartmentMate';
	import Notifications from './Notifications';
	import Documents from './Documents';
	import Items from './Items';
	import Splitter from "./Splitter";
	import Rules from './Rules';

    export default {
        name: "Dashboard",
        components: {ApartmentMate, Notifications, Documents, Items, Splitter, Rules}
    }
</script>