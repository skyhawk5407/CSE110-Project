import Vue from 'vue'
import VueRouter from 'vue-router';

import Login from './components/pages/Login'
import Profile from './components/pages/Profile'
import AccountCreation from './components/pages/AccountCreation'
import Dashboard from './components/pages/Dashboard'
import Dashboard_i from './components/pages/Dashboard_initial'
import ExamplePage from './components/pages/ExamplePage'

Vue.use(VueRouter);

const routes = [
  { path: '/Login', component: Login },
  { path: '/Profile', component: Profile },
  { path: '/AccountCreation', component: AccountCreation },
  { path: '/Dashboard', component: Dashboard },
  { path: '/Dashboardi', component: Dashboard_i },
  { path: '/example', component: ExamplePage },
  { path: '*', redirect: '/Login' }
];

export default new VueRouter({
  mode: 'history',
  routes
});