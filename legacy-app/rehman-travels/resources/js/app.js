import '../css/app.css';
import '@fortawesome/fontawesome-free/css/all.css';
import Toaster from '@meforma/vue-toaster';
import {createApp, h} from 'vue';
import {createInertiaApp} from '@inertiajs/vue3';
import {resolvePageComponent} from 'laravel-vite-plugin/inertia-helpers';
import {ZiggyVue} from '../../vendor/tightenco/ziggy/dist/vue.m';
const appName = import.meta.env.VITE_APP_NAME || 'Rehman Group Of Companies Islamabad Pakistan';
import store from '../js/store.js'
import print from 'vue3-print-nb'
import vue3ToPdf from 'vue3-to-pdf'
import SearchLoader from '@/Components/SearchLoader.vue'
import LoadingPopup from '@/Components/LoadingPopup.vue'
createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({el, App, props, plugin}) {
        return createApp({render: () => h(App, props)})
            .use(plugin)
            .use(ZiggyVue, Ziggy)
            .use(print)
            .use(vue3ToPdf)
            .use(store)
            .use(Toaster, {position: 'top-right'})
            .component('search-loader', SearchLoader)
            .component('loading-popup', LoadingPopup)
            .mount(el);
    },
    progress: {
        color: '#4B5563',
    },
});
