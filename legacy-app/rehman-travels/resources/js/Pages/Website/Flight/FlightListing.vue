<script setup>
import SearchFlight from '@/Layout/Website/SearchFlight.vue';
import GuestLayout from "@/Layouts/GuestLayout.vue";
import TheIntroduction from "../Common/Introduction/TheIntroduction.vue";
</script>
<template>
    <GuestLayout v-slot="{selectedCurrencyFromParent}" :selectedCurrencyFromChild="selectedCurrencyFromChild">
        <SearchFlight @selectedCurrencyFromChildToParent="selectedCurrencyFromChildToParent" :selectedCurrencyFromParent="selectedCurrencyFromParent"/>
        <div class="-mt-56 md:-mt-28">
            <TheIntroduction />
            <!-- Contact Form -->
            <div class="md:px-4 py-4 xs:p-6 mx-auto w-[90%] sm:w-[78%] xl:w-[88%] 2xl:w-[78%]">
                <div class="bg-white rounded-lg xs:text-justify">
                    <div class="my-3 w-full">
                        <h3 class="text-xl uppercase rounded bg-bgRGTBaseColor text-white p-[0rem_0.7rem] mb-3 font-medium leading-[2.875rem] md:text-start text-center">
                            request a callback
                        </h3>
                    </div>
                    <form class="w-full px-4 py-2" @submit.prevent="submit">
                        <div class="grid grid-cols-12 gap-2">
                            <div class="col-span-12 md:col-span-4">
                                <input v-on:keypress="isString" @paste.prevent
                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="text" v-model="form.customers.firstName" placeholder="Your Name">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input v-on:keypress="isNumber" @paste.prevent
                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="number" v-model="form.customers.mobileNo" placeholder="Phone No">
                            </div>
                            <div class="col-span-12 md:col-span-4">
                                <input v-on:keypress="isEmail" @paste.prevent
                                class="appearance-none block w-full h-10 border border-gray-300 hover:border-gray-400 rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white focus:border-blue-500"
                                type="email" v-model="form.customers.email"  placeholder="Email">
                            </div>
                        </div>
                        <div class="grid grid-cols-12 gap-3">
                            <div class="col-span-12 md:col-span-8">
                                <textarea cols="40" v-model="form.contents.message" v-on:keypress="isString" @paste.prevent
                                class="appearance-none block h-10 w-full border border-gray-300 hover:border-gray-400 rounded px-4 mb-3 focus:outline-none focus:bg-white focus:border-blue-500"
                                > Message</textarea>
                            </div>
                            <div class="col-span-12 md:col-span-2 md:mb-0 mb-4">
                                <input type="submit" @click="submitDetails()"
                                    class=" w-full p-2 text-xl bg-blue-100 text-blue-800 border border-solid border-blue-500 text-center transition-all duration-700 ease-in-out rounded hover:bg-bgRGTBaseColor hover:text-white hover:transition-all hover:ease-in-out hover:duration-700">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </GuestLayout>
</template>

<script>
export default {
    name: 'Flight',
    components: {
        SearchFlight,
        TheIntroduction
    },
    data(){
        return{
            selectedCurrencyFromParent: {type:Object},
            selectedCurrencyFromChild:{type:Object},
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 3,
                    leadFrom : "Flights"
                }
            },
        }
    },
    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isNumber(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmail(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        submitDetails(){
            if(this.form.customers.mobileNo == ""){
                this.$toast.error("Please Enter  mobile No.");
                return false;
            }else{
                this.$inertia.post('/addContactDetails', this.form,{
                    onSuccess: (response) => {
                        window.location.href = '/Website/thankYou';
                    }
                });
            }
        },
        selectedCurrencyFromChildToParent(currency){
            this.selectedCurrencyFromChild = currency;
        }
    }
}
</script>