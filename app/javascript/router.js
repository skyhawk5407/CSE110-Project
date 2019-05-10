import Vue from 'vue';
import VueRouter from 'vue-router';

import Login from './components/pages/Login';
import Two from './components/pages/Two';
import Dashboard from './components/pages/Dashboard';
import Notifications from './components/pages/Notifications';

Vue.use(VueRouter);

const routes = [
  { path: '/Login', component: Login },
  { path: '/two', component: Two },
  { path: '/Dashboard', component: Dashboard },
  { path: '/Notifications', component: Notifications},
  { path: '*', redirect: '/Login' }
];

export default new VueRouter({
  mode: 'history',
  routes
});