<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>

<template>
    <GuestLayout>
        <section>
            <div class="banner md:h-[275px] h-[250px]" :style="'background-image:url('+banner+')'">
                <h2
                    class="text-white text-[29px] sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center md:py-28 py-16 sm:px-24 ">
                    Contact Us</h2>
            </div>
            <form @submit.prevent="submit">
                <div
                    class="w-11/12 max-w-screen-xl -mt-16 px-4 grid gap-8 grid-cols-1 md:grid-cols-2 md:px-12 lg:px-11 xl:px-32 py-16 pb-4 mx-auto bg-white text-gray-900 rounded-lg shadow-[4px_2px_8px_0px_#a3a3a3d6] mb-5">
                    <div class="flex flex-col justify-between">
                        <div>
                            <h2 class="text-4xl lg:text-5xl font-bold leading-tight">Lets talk about Everything!</h2>
                            <div class="text-gray-700 mt-8">
                                Send us an <span class="underline">Email</span> instead.
                            </div>
                            <div class="mb-2 mt-4" v-if="$page.props.getNum.landline">
                                <a :href="'tel:'+ $page.props.getNum.landline">
                                    <i class="fa fa-headset"></i>
                                    <span class="pl-3 text-md text-black">{{ $page.props.getNum.landline }}</span>
                                </a>
                            </div>
                            <div class="mb-2 mt-2">
                                <a href="mailto:info@rehmantravel.com">
                                    <i class="fa fa-envelope-open-text"></i>
                                    <span class="pl-3 text-md text-black">info@rehmantravel.com</span>
                                </a>
                            </div>
                            <div class="mb-2 mt-2" v-if="$page.props.getNum.address">
                                <a :href="$page.props.getNum.googleMap">
                                    <i class="fa fa-map-marked-alt"></i>
                                    <span class="pl-3 text-md text-black" :href="$page.props.getNum.googleMap">{{ $page.props.getNum.address }}</span>
                                </a>
                            </div>
                        </div>
                        <div class="mt-8 text-center">
                            <img src="assets/contact-us/Cross.webp" />
                        </div>
                    </div>
                    <div>
                        <div>
                            <span class="uppercase text-sm text-gray-600 font-bold">Full Name</span>
                            <input v-model="form.customers.firstName"
                                v-on:keypress="isString" @paste.prevent
                                class="w-full border border-solid border-black/40 text-gray-900 mt-2 p-3 rounded-md focus:outline-none focus:shadow-outline placeholder:text-sm focus:border focus:border-1 focus:border-blue-400 focus:border-solid"
                                type="text" placeholder="Please Enter Your Full Name">
                        </div>
                        <div class="mt-2">
                            <span class="uppercase text-sm text-gray-600 font-bold">Phone</span>
                            <input v-model="form.customers.mobileNo"
                                v-on:keypress="isNumber" @paste.prevent
                                class="w-full border border-solid border-black/40 text-gray-900 mt-2 p-3 rounded-md focus:outline-none focus:shadow-outline placeholder:text-sm focus:border focus:border-1 focus:border-blue-400 focus:border-solid"
                                type="tel" placeholder="Please Enter Your Phone No">
                        </div>
                        <div class="mt-2">
                            <span class="uppercase text-sm text-gray-600 font-bold">Email</span>
                            <input v-model="form.customers.email"
                                v-on:keypress="isEmail" @paste.prevent
                                class="w-full border border-solid border-black/40 text-gray-900 mt-2 p-3 rounded-md focus:outline-none focus:shadow-outline placeholder:text-sm focus:border focus:border-1 focus:border-blue-400 focus:border-solid"
                                type="email" placeholder="Please Enter Your Email">
                        </div>
                        <div class="mt-2">
                            <span class="uppercase text-sm text-gray-600 font-bold">Message</span>
                            <textarea rows="5" v-model="form.contents.message"
                                v-on:keypress="isString" @paste.prevent
                                class="w-full border border-solid border-black/40 text-gray-900 mt-2 p-3 rounded-md focus:outline-none focus:shadow-outline placeholder:text-sm focus:border focus:border-1 focus:border-blue-400 focus:border-solid"
                                placeholder="Enter Your Message"></textarea>
                        </div>
                        <div class="mt-2">
                            <button @click="submitDetails()"
                                class="uppercase text-sm font-bold tracking-wide bg-bgRGTBaseColor text-gray-100 p-3 rounded-lg w-full focus:outline-none focus:shadow-outline hover:bg-blue-800 duration-700 ease-in-out transition-all hover:duration-700 hover:ease-in-out hover:transition-all">
                                Send Message
                            </button>
                        </div>
                    </div>
                </div>
            </form>
            <div class="w-[90%] mx-auto"
                v-if="$page.props.getNum.whatsapp || $page.props.getNum.landline"
            >
                <div class="gird grid-cols-12 mb-4">
                    <div class="col-span-10 w-[90%] mx-auto">
                        <h3 class="capitalize bg-bgRGTBaseColor p-3 text-white text-2xl rounded mb-5 md:pl-4">Find Us on Google Map.</h3>
                    </div>
                    <div class="col-span-10 mx-auto">
                        <div class="map_inner">
                            <div class="md:ml-16">
                                <iframe src="https://storage.googleapis.com/maps-solutions-poi8j88sjk/locator-plus/seoq/locator-plus.html"
                                height="450" width="95%" frameborder="0" style="border:0; box-shadow: 0px 0px 6px 1px #4e4e4e;" allowfullscreen="" loading="lazy"> </iframe>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="w-[82%] mx-auto" v-if="$page.props.getNum.whatsapp || $page.props.getNum.landline">
                <div class="grid grid-cols-12 gap-3">
                    <div class="col-span-12">
                        <h3 class="capitalize bg-bgRGTBaseColor p-3 text-white text-2xl rounded mb-5 md:pl-4">Our Branches
                        </h3>
                    </div>
                    <div v-for="(branch, brancheIndex) in branches" :key="brancheIndex"
                        class="block col-span-12 lg:col-span-3 md:col-span-4 xs:col-span-6 shadow-[0px_0px_6px_1px_#4e4e4e] mb-5">
                        <iframe v-if="branch.mapAddress != '#'" class="card-img-top" :src="branch.mapAddress" width="600"
                            height="450" style="height: 225px; width: 100%; display: block; border:0;" allowfullscreen=""
                            loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                        <iframe v-else src="https://maps.app.goo.gl/CZGkiXx2DJzXieuQ7"  width="600" height="450" style="height: 225px; width: 100%; display: block; border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                        <div class="p-[1rem_1rem]">
                            <p class="text-sm text-black leading-6"><i class="fas fa-location"></i><span
                                    class="text-rGTBaseTextColor text-lg">{{ branch.branchName }}</span><br>{{
                                        branch.branchAddress }}</p>
                            <div class="flex justify-between items-center">
                                <small class="text-gray-500"><a target="_blank" :href="'tel:'+ branch.branchPhone">Ph: {{ branch.branchPhone }}</a></small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>

<script>

export default {
    name: 'Contact Us',
    props: {
        branches: { type: Object }
    },
    data() {
        return {
            banner : "",
            form: {
                customers: {
                    firstName : "",
                    mobileNo : "",
                    email : "",
                },
                contents: {
                    message : "",
                    moduleId : 10,
                    leadFrom : "Contact Us"
                }
            },
        }
    },
    mounted(){
        this.banner = "/assets/contact-us/contact-us-banner.webp";
    },
    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z @.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isEmail(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z 0-9@.]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        isNumber(e){
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[0-9+]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        submitDetails() {
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
        }
    }
}
</script>
