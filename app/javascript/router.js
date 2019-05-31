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
import ResetPassword from './components/pages/ResetPassword'

import store from './store.js'

Vue.use(VueRouter);

const routes = [
  { path: '/Login', component: Login, meta: {notLoggedIn: true}},
  { path: '/AccountSettings', component: AccountSettings, meta: {auth: true}},
  { path: '/AccountCreation', component: AccountCreation, meta: {notLoggedIn: true} },
  { path: '/Dashboard', component: Dashboard, meta: {auth: true, apartment:true}},
  { path: '/Dashboardi', component: Dashboard_i, meta: {auth: true, notApartment:true} },
  { path: '/example', component: ExamplePage },
  { path: '/SplashScreen', component: SplashScreen},
  { path: '/Expenses', component: Expenses, meta: {auth: true, apartment:true}},
  { path: '/ApartmentMate', component: ApartmentMate, meta: {auth: true, apartment:true}},
  { path: '/Documents', component: Documents, meta: {auth: true, apartment:true}},
  { path: '/Items', component: Items, meta: {auth: true, apartment:true}},
  { path: '/Notifications', component: Notifications, meta: {auth: true, apartment:true}},
  { path: '/Rules', component: Rules, meta: {auth: true, apartment:true}},
  { path: '/ResetPassword', component: ResetPassword, meta: {notLoggedIn: true}},
  { path: '*', redirect: '/SplashScreen' }
];

const router = new VueRouter({
  mode: 'history',
  routes
});

router.beforeEach((to, from, next) => {
  // If not logged in, don't show certain pages
  if(to.meta.auth && !store.state.username){
    next('/');
    // if logged in, don't show other pages
  } else if(to.meta.notLoggedIn && store.state.username) {
    next('/');
  // } else if(to.meta.notApartment && store.state.apartmentId !== undefined) {
  //   next('/Dashboard');
  // } else if(to.meta.apartment && store.state.apartmentId === undefined) {
  //   next('/Dashboardi');
  } else {
    next();
  }
});

export default router;
