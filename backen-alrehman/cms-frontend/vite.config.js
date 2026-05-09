import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig(({ mode }) => {
  // Load env file based on mode
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [react()],
    server: {
      port: parseInt(env.VITE_PORT) || 3000,
      host: true, // Listen on all addresses
      cors: true,
      proxy: {
        // Optional: Proxy API requests to avoid CORS in development
        // '/api': {
        //   target: env.VITE_API_URL || 'http://localhost:8000',
        //   changeOrigin: true,
        // }
      }
    },
    preview: {
      port: parseInt(env.VITE_PORT) || 3000,
      host: true,
    }
  }
})
