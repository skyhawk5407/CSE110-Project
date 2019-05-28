import Vue from 'vue'
import VueRouter from 'vue-router';

import Login from './components/pages/Login'
import AccountSettings from './components/pages/AccountSettings'
import AccountCreation from './components/pages/AccountCreation'
import Dashboard from './components/pages/Dashboard'
import Dashboard_i from './components/pages/Dashboard_initial'
import ExamplePage from './components/pages/ExamplePage'
import SplashScreen from './components/pages/SplashScreen'
import Expenses from './components/pages/Expenses'

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
  { path: '*', redirect: '/SplashScreen' },
];

export default new VueRouter({
  mode: 'history',
  routes
});