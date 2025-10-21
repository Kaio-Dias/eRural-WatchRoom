import { createRouter, createWebHistory } from 'vue-router'
import HomePage from '../views/HomePage.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomePage
  },
  {
    path: '/rooms/:slug',
    name: 'room',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
        component: () => import(/* webpackChunkName: "about" */ '../views/RoomPage.vue')
  }
]

const router = createRouter({
  history: createWebHistory('/'),
  routes
})

export default router
