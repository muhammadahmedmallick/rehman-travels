/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f4ff',
          100: '#e0e9ff',
          200: '#c7d6fe',
          300: '#a5bbfd',
          400: '#8199fa',
          500: '#6377f5',
          600: '#4b54e9',
          700: '#3d44ce',
          800: '#323aa6',
          900: '#1a1b4b',
        },
      },
    },
  },
  plugins: [],
}
