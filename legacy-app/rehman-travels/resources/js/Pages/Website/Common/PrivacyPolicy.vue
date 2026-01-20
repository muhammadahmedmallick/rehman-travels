<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>
<template>
    <GuestLayout>
        <section class="bg-white">
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
                <h2
                    class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">
                    Privacy Policy</h2>
            </div>
            <div class="w-[90%] mx-auto border border-1 border-gray-300 rounded-md">
                <div class="grid grid-cols-12 bg-[#0181dd] rounded-t-md ">
                    <div class="col-span-12 lg:col-span-6">
                        <p class="text-center lg:text-left  text-white py-2 lg:pl-4 text-xl font-bold capitalize">Privacy
                            Policy
                        </p>
                    </div>
                </div>
                <div class="mt-3 pb-6 px-6 border-b border-1 border-dashed border-gray-500 ck-Detail">
                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">Your Privacy Is
                        Important To Us</h4>
                    <p class="text-justify text-sm text-gray-700 leading-7 tracking-tighter-[.3px]">
                        Your privacy is important to Us, and as a valued customer that means it is important to us. We are
                        committed to protecting any
                        personal information you entrust to us. This page describes how we use and will not use your
                        personal
                        information. From time to time
                        we may change this information so please check this page regularly.
                    </p>
                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">What kind of
                        personal
                        information does rehmantravel.com ask for?</h4>
                    <p class="text-justify text-sm text-gray-700 leading-7 tracking-tighter-[.3px]">
                        When you make a booking with rehmantravel.com, we will ask for your name, address, email address,
                        telephone number. To make it easier to make and manage bookings we save only your name, address,
                        and email and telephone number.
                        If you choose to pay online, we will ask for your payment information via our secure online payment
                        provider. We know that your credit/debit card
                        information is very sensitive, so unlike other booking websites, we don’t save any card information.
                    </p>

                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">What does
                        rehmantravel.com use your personal information for and who do we share it with?</h4>
                    <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                        <li><span class="font-semibold text-sm text-gray-900">Bookings : </span>
                            We use the information you give us to manage your bookings, and to share some of it with the
                            flights
                            provider so that they know who to expect.
                        </li>
                        <li><span class="font-semibold text-sm text-gray-900">Customer Service :</span>
                            Giving the best customer service possible is very important to us. We use your information to
                            make
                            sure we serve you as well as we can.
                        </li>
                        <li><span class="font-semibold text-sm text-gray-900">Account administration and personalisation
                                :</span>
                            We link all of your bookings to your account, using your information and booking history to
                            allow
                            you to manage your account in the most user friendly way possible.
                        </li>
                        <li><span class="font-semibold text-sm text-gray-900">Guest reviews :</span>
                            We’ll use your information to contact you following a stay, asking you to rate the bookings and
                            our
                            website to help future visitors to rehmantravel.com.
                        </li>

                    </ul>
                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">When does rehmantravel.com share your data with third parties?</h4>
                    <p class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                        Flights partners: We share your relevant personal information (but not your payment card
                        information)
                        with the flights provider so they can know who to expect and
                        prepare as per your booking. This may include names of those travelling, contact details, and
                        booking
                        preferences.
                    </p>
                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">How does
                        rehmantravel.com use mobile devices?</h4>
                    <p class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                        We have a version of our website optimised specifically for mobile devices and a mobile app. The way
                        we
                        use and share your personal information when you access our site
                        via mobile is much the same as for the regular website, with the addition that they may use location
                        services to tailor the experience to where you are at the time.
                    </p>
                    <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">Help Line</h4>
                    <p class="leading-7 tracking-tighter-[.3px]"> <span class="text-[#006ee3] font-bold"> Email:</span> helpdesk@rehmantravel.com</p>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
export default {
    name: "PrivacyPolicy",
    data() {
        return {
            banner: "",
        };
    },
    mounted() {
        this.banner = '/assets/Visa/dubai-banner.webp';
    },
};
</script>