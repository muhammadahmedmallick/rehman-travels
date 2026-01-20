<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>

<template>
    <GuestLayout>
        <section class= "bg-white">
           <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url(' + banner + ')'">
               <h2 class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">Terms and Conditions</h2>
            </div>
           <div class="w-[90%] mx-auto border border-1 border-gray-300 rounded-md">
               <div class="grid grid-cols-12 bg-[#0181dd] rounded-t-md ">
                       <div class="col-span-12 lg:col-span-6">
                           <p class="text-center lg:text-left  text-white py-2 lg:pl-4 text-xl font-bold capitalize">Terms and Conditions</p>
                       </div>
               </div>
               <div class="mt-3 pb-6 px-6 border-b border-1 border-dashed border-gray-500 ck-Detail">
                   <p class="text-justify text-sm text-gray-700 leading-7 tracking-tighter-[.3px]">
                       Please read these Terms and Conditions carefully before using the services offered by Rehman Travels. 
                       These terms govern your use of our website and the purchase of airline tickets online using a debit/credit card.
                       By accessing our website and making a booking, you agree to comply with these terms. If you do not agree with 
                       any part of these terms, please refrain from using our services.
                   </p>
                   <h4 class="text-[#006ee3] mt-3 mb-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">1.Booking and Payment</h4>
                   <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Eligibility :</span>
                           To make a booking through Rehman Travels, you must be at least 18 years old or have 
                           the consent of a parent or legal guardian. By making a booking, you confirm that you 
                           have the necessary authority to enter into a contract and accept financial responsibility for the transaction.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Accuracy of Information :</span>
                           You are responsible for providing accurate and complete information during the booking process.
                           This includes passenger names, contact details, and payment information. 
                           Rehman Travels is not liable for any errors or consequences resulting from inaccurate or incomplete information provided by you.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Payment :</span>
                           Payment for airline tickets must be made using a valid debit/credit card. 
                           By providing your credit card information, you authorize Rehman Travels to charge
                            the specified amount for the ticket purchase. The payment will be processed securely 
                            and in accordance with industry standards.
                       </li>
                       <li>
                           <span class="font-semibold text-sm text-gray-900">Fare Rules :</span>
                           Each airline has specific fare rules associated with the tickets they offer.
                            It is important to review and understand these fare rules before making a booking.
                             Fare rules may include restrictions, penalties, and cancellation policies that govern 
                             ticket changes, cancellations, and refunds. By making a booking, you agree to abide by
                              the fare rules imposed by the airline.
                       </li>
                   </ul>
                   <h4 class="text-[#006ee3] mt-3 mb-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">2.Booking Confirmation and Travel Documents</h4>
                       <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                           <li>
                               <span class="font-semibold text-sm text-gray-900">Confirmation :</span>
                               Upon completion of the booking process and successful payment, you will receive a 
                               confirmation email containing your booking details. It is your responsibility to review
                                the booking confirmation and ensure all information is correct.
                           </li>
                           <li>
                               <span class="font-semibold text-sm text-gray-900">Travel Documents :</span>
                               It is your responsibility to ensure that you possess the necessary travel documents,
                               such as passports, visas, and health certificates, required for your itinerary.
                               Rehman Travels is not responsible for any issues or denied boarding resulting from
                               the absence or invalidity of the required travel documents
                           </li>
                       </ul>
                   <h4 class="text-[#006ee3] mt-3 mb-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">3. Changes, Cancellations, and Refunds</h4>
                       <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                               <li>
                                   <span class="font-semibold text-sm text-gray-900">Changes :</span>
                                   Changes to your booking, such as date modifications or passenger name corrections,
                                   may be subject to airline-imposed penalties and fare differences. Rehman Travels will
                                   assist you in making the necessary changes, but please note that any fees or charges
                                   incurred are your responsibility.
                               </li>
                               <li>
                                   <span class="font-semibold text-sm text-gray-900">Cancellations and Refunds :</span>
                                   Cancellation policies and refund eligibility vary depending on the fare rules of the airline.
                                    Some tickets may be non-refundable, while others allow for cancellations with a refund, subject
                                     to certain conditions. Rehman Travels will help facilitate the cancellation process and apply for 
                                     a refund on your behalf, in accordance with the airline's policies. Please refer to our Refund 
                                     Policy for more details.
                               </li>
                       </ul>
                   <h4 class="text-[#006ee3] mt-3 mb-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">4.Limitation of Liability</h4>
                       <ul class="list-decimal text-justify text-sm text-gray-700 pl-6 leading-7 tracking-tighter-[.3px]">
                               <li>
                                   <span class="font-semibold text-sm text-gray-900">Service Provision :</span>
                                   Rehman Travels acts as an intermediary between you and the airlines, hotels, car rental
                                   companies, and other service providers. While we strive to provide accurate and up-to-date 
                                   information, we do not guarantee the availability, accuracy, or reliability of the services
                                   provided by third-party providers. Rehman Travels shall not be liable for any losses, damages,
                                   or inconvenience arising from the actions or omissions of these third-party providers.
                               </li>
                               <li>
                                   <span class="font-semibold text-sm text-gray-900">Indirect Damages :</span>
                                   In no event shall Rehman Travels be liable for any indirect, incidental, consequential, 
                                   or punitive damages arising out of your use of our services, including but not limited to 
                                   loss of profits, data, or business opportunities.
                               </li>
                       </ul>
                       <p>By using our services, you acknowledge that you have read, understood, and agreed to these Terms and Conditions</p>
                   <h4 class="text-[#006ee3] mt-3 mb-3 text-xl font-bold leading-7 tracking-tighter-[.3px]">Help Line</h4>
                   <p class="leading-7 tracking-tighter-[.3px]"> <span class="text-[#006ee3] font-bold"> Email:</span> helpdesk@rehmantravel.com</p>
               </div>
           </div>
       </section>
    </GuestLayout>
</template>
<script>
export default {
    name: "TermsandConditions",
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