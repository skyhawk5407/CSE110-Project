import Vue from 'vue'
import VueRouter from 'vue-router';

import Login from './components/pages/Login'
import Two from './components/pages/Two'

Vue.use(VueRouter);

const routes = [
  { path: '/Login', component: Login },
  { path: '/two', component: Two },
  { path: '*', redirect: '/Login' }
];

export default new VueRouter({
  mode: 'history',
  routes
});