<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>

<template>
    <GuestLayout>
        <section class= "bg-white">
           <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
               <h2 class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">Refund Policy</h2>
            </div>
           <div class="w-[90%] mx-auto border border-1 border-gray-300 rounded-md">
               <div class="grid grid-cols-12 bg-[#0181dd] rounded-t-md ">
                       <div class="col-span-12 lg:col-span-6">
                           <p class="text-center lg:text-left  text-white py-2 lg:pl-4 text-xl font-bold capitalize">Refund Policy</p>
                       </div>
               </div>
               <div class="mt-3 pb-6 px-6 border-b border-1 border-dashed border-gray-500 ck-Detail">
                   <p class="text-justify text-sm text-gray-700 leading-7 tracking-tighter-[.3px]">
                       At Rehman Travels, we strive to provide exceptional service and customer satisfaction when it comes to booking airline tickets online. 
                       We understand that plans can change, and sometimes it becomes necessary to seek a refund for your purchased ticket. This refund policy outlines 
                       the terms and conditions under which refunds are processed. Please read this policy carefully before making your purchase.
                   </p>
                   <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">1.Refund Eligibility</h4>
                   <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Cancellations by the Travelers :</span>
                           If you decide to cancel your ticket, the eligibility for a refund and the refund amount will depend on the fare rules associated with
                           your booking. Some fares may be non-refundable, while others may allow for cancellations with a refund, subject to certain conditions.
                           It is important to review the fare rules and cancellation policy for your specific ticket before making a purchase.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Cancellations by the Airline :</span>
                           In case the airline cancels your flight, you may be entitled to a full or partial refund, depending on 
                           the airline's policy. We will make every effort to inform you of any changes or cancellations made by the
                           airline, and assist you in obtaining a refund or rebooking your travel arrangements.
                       </li>
                   </ul>
       
                   <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">2.Refund Process</h4>
                   <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Initiation : </span>
                           To request a refund, you must contact our customer support team via email or phone within the specified time 
                           frame mentioned in the fare rules or cancellation policy. Please provide your booking details, including the 
                           airline confirmation number, passenger names, and any other relevant information.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Verification :</span>
                           Our team will review your refund request and verify the eligibility based on the fare rules and cancellation policy. 
                           We may require additional information or documentation to process your refund efficiently
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Refund Amount :</span>
                           If your refund request is approved, the refund amount will be determined according to the fare rules associated with your
                           ticket. In some cases, airline penalties, administrative fees, and our service charges may apply, which will be deducted
                           from the total refund amount.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Refund Method :</span>
                           The refund will be credited back to bank or cross cheque in the name of traveler/passenger.
                       </li>
       
                   </ul>
                   <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">3. Non-Refundable Fees and Charges</h4>
                   <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Service Fees : </span>
                           Service fees charged by Rehman Travels for the ticket booking are non-refundable, 
                           except in cases where the airline cancels the flight or if there are exceptional circumstances.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Credit Card Charges :</span>
                           Any credit card transaction fees or charges incurred during the ticket purchase are non-refundable,
                           as they are associated with the payment processing and are not within our control.
                       </li>
                   </ul>
                   <h4 class="text-[#006ee3] mt-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">4.Changes to the Refund Policy</h4>
                   <p class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                       Rehman Travels reserves the right to modify or update this refund policy at any time without prior notice. Any changes made
                        will be effective immediately upon posting on our website. We recommend visiting our refund policy page regularly to stay informed 
                        about any updates.
                       Disclaimer: This refund policy applies only to airline ticket bookings made through Rehman Travels website. For other travel-related 
                       services or products, such as hotel reservations or car rentals, please refer to the respective service provider's refund policy.
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
    name: "RefundPolicy",
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