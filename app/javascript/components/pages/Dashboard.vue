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
			  <b-tab title="Expenses">
                  <Expenses></Expenses>
			  </b-tab>
			  <b-tab title="Notifications">
                  <Notifications></Notifications>
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
	import Expenses from "./Expenses";
	import Rules from './Rules';

    export default {
        name: "Dashboard",
        components: {ApartmentMate, Notifications, Documents, Items, Expenses, Rules}
    }
</script>
