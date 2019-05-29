import Vue from 'vue'
import VueRouter from 'vue-router';

import Login from './components/pages/Login'
import AccountSettings from './components/pages/AccountSettings'
import AccountCreation from './components/pages/AccountCreation'
import Dashboard from './components/pages/Dashboard'
import Dashboard_i from './components/pages/Dashboard_initial'
import ExamplePage from './components/pages/ExamplePage'
import SplashScreen from './components/pages/SplashScreen'
import ApartmentMate from './components/pages/ApartmentMate'
import Documents from './components/pages/Documents'
import Items from './components/pages/Items'
import Rules from './components/pages/Rules'
import Expenses from './components/pages/Expenses'
import Notifications from './components/pages/Notifications'

Vue.use(VueRouter);

const routes = [
  { path: '/Login', component: Login },
  { path: '/AccountSettings', component: AccountSettings },
  { path: '/AccountCreation', component: AccountCreation },
  { path: '/Dashboard', component: Dashboard },
  { path: '/Dashboardi', component: Dashboard_i },
  { path: '/example', component: ExamplePage },
  { path: '/SplashScreen', component: SplashScreen},
  { path: '/Expenses', component: Expenses},
  { path: '/ApartmentMate', component: ApartmentMate},
  { path: '/Documents', component: Documents},
  { path: '/Items', component: Items},
  { path: '/Notifications', component: Notifications},
  { path: '/Rules', component: Rules},
  { path: 'AccountSettings', component: AccountSettings},
  { path: '*', redirect: '/SplashScreen' },
];

export default new VueRouter({
  mode: 'history',
  routes
});
