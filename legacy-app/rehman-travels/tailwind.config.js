import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Jost', ...defaultTheme.fontFamily.sans],
            },
            screens: {
                'xs': '500px',
                'xxs': '422px',
            },        
            backgroundImage: {
                //Navbar
                gradient: 'var(--color-gradient)',
            },
            colors:{
              // Main Color
              txtColor: 'var(--color-txt-color)',
      
              // Navbar List Items
              NavListItemtxtHover:'var(--color-nav-list-item-txtHover)',
              ListItemHoverUnderline:'var(--color-nav-list-item-hover-underline)',
      
              // Navbar Dropdown Menu
              NavdropBg: 'var(--color-navdrop-bg)',
              NavdropText:'var(--color-navdrop-text)',
              NavdropBorderLeft:'var(--color-navdrop-border-left)',
              
              //Hover: Navbar Dropdown Menu
              NavdropHoverBg:'var(--color-navdrop-hover-bg)',
              NavdropHoverText:'var(--color-navdrop-hover-text)',
              // Button
              BtntxtColor:'var(--color-btn-txt-color)',
              BtnBgColor:'var(--color-btn-bg-color)',
      
              // Hover: Button
              BtntxtHover:'var(--color-btn-txt-hover)',
              BtnBgHover: 'var(--color-btn-bg-hover)', 
              textWhite: 'var(--textWhite)', 

              //Theme Color
              bgRGTBaseColor: 'var(--bgRGTBaseColor)',
              rGTBaseTextColor: 'var(--rGTBaseTextColor)',
              rGTBorderColor: 'var(--rGTBorderColor)',
            }
        },
    },

    plugins: [forms],
};
