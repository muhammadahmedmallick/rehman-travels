import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
export default defineConfig({
    base: './',
    plugins: [
        laravel({
            buildDirectory: "../../public_html/build",
            input:['resources/css/app.css', 'resources/js/app.js'],
              
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    build: {
      minify: true,   
      cssCodeSplit: true,   
      manifest: 'manifest.json',
    },
    optimizeDeps: {
        exclude: [
            "@meforma/vue-toaster"
        ]
    },
});
