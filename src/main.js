/** Importing of vue */
import Vue from 'vue'

/** Importing base component */
import Home from './Home.vue'

/** Importing stylesheets */
import 'bootstrap/dist/css/bootstrap.css'
import './assets/css/acolors.min.css'

/** Production tips */
Vue.config.productionTip = false

/** System bus to pass event between components */
export const bus = new Vue();

/** Vue Instance */
new Vue({render: h => h(Home)}).$mount('#app')
