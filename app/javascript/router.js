import Vue from 'vue'
import VueRouter from 'vue-router';

import One from './components/pages/One'
import Two from './components/pages/Two'

Vue.use(VueRouter);

const routes = [
  { path: '/one', component: One },
  { path: '/two', component: Two },
  { path: '*', redirect: '/one' }
];

export default new VueRouter({
  mode: 'history',
  routes
});