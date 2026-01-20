<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>
<template>
    <GuestLayout>
        <div class="px-2 md:px-4 py-4 xs:p-6 mx-auto w-[90%] sm:w-[78%] xl:w-[50%]">
            <div class="p-4 rounded shadow-lg ring ring-indigo-600/50">
                <div class="flex flex-col items-center space-y-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="text-green-600 w-28 h-28" fill="none" viewBox="0 0 24 24"
                        stroke="currentColor" stroke-width="1">
                        <path stroke-linecap="round" stroke-linejoin="round"
                            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <h1 class="text-4xl font-bold text-rGTBaseTextColor">Welcome</h1>
                    <div class="justify-start leading-[1.7]">
                        <p>We have received your message and would like to thank you for writing to us.</p>
                        <p>For Urgent inquiry Contact on the below mentioned details:</p>
                        <br>
                        <h1 class="text-2xl md:text-4xl font-bold text-rGTBaseTextColor">Our Contact Details :</h1>
                        <p><a href="tel:+9251111786785"><b>Phone :</b> +92-51-111-786-785</a></p>
                        <p><a href="mailto:info@rehmantravel.com"><b>Email :</b> info@rehmantravel.com</a></p>
                        <p><b>Address :</b> Head Office 01 & 03, Allay Plaza, Near PIA Head Office, Fazl-e-Haq Road Blue Area, Islamabad, Pakistan.</p>
                        <p><b>Bank Details :</b> Check out <a href="/bank-details"><b class="text-rGTBaseTextColor">our banks</b></a></p>
                        <p>Please check <a href="/contactUs"><b class="text-rGTBaseTextColor">our Contact Us</b></a> page for more information.</p>
                        <p>Have a great day ahead!</p>
                    </div>

                    <a href="/"
                        class="inline-flex items-center px-4 py-2 text-white bg-rGTBaseTextColor border border-rGTBorderColor rounded-full hover:bg-indigo-700 focus:outline-none focus:ring">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 mr-2" fill="none" viewBox="0 0 24 24"
                            stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M7 16l-4-4m0 0l4-4m-4 4h18" />
                        </svg>
                        <span class="text-sm font-medium">
                            Home
                        </span>
                    </a>
                </div>
            </div>
        </div>
    </GuestLayout>
</template>