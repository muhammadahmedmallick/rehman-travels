<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head>
        <title>Visa - Rehman Travel</title>
    </Head>
    <GuestLayout>
        <section class="bg-gray-200">
            <div class="banner" :style="'background-image:url('+banner+')'">
                <h1 class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">
                    Our Visa Offers For Various Countries</h1>
            </div>
            <!-- Card Design -->

            <div class="md:w-[95%] sm:[95%] my-12 mx-auto px-4 md:px-16">
                <div class="flex flex-wrap -mx-1 ">
                    <div v-for="(VisaPackage, VisaPackageIndex) in getallVisa" :key="VisaPackageIndex" class="my-1 px-1 w-full xs:w-11/12 xs:mx-auto sm:w-1/2 lg:my-4  lg:w-1/3 lg:px-3">
                        <a :href="VisaPackage.urlLink" class="relative flex justify-center items-center">
                            <div class=" rounded-[10px] w-full hover:bg-white">
                                <img :alt="VisaPackage.packageTitle"
                                    class="block sm:h-[26rem] w-full  hover:opacity-100 rounded-lg hover:rounded-[1rem] hover:p-[10px] ease-in-out duration-300  hover:ease-in-out hover:duration-300 border-white border-[1px]"
                                    :src="''+ VisaPackage.image">
                            </div>
                            <div class="absolute">
                                <h1 class="text-white font-bold text-xl md:text-2xl xl:text-[2rem] drop-shadow-[2px_2px_1px_black] capitalize">
                                    {{ VisaPackage.packageTitle }}</h1>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </GuestLayout>
</template>
<script>
export default {
    name: 'getallVisa',
    props: {
        getallVisa: { type: Object }
    }
    ,data(){
        return{
            banner:"",
        }
    },
    mounted(){
        this.banner = '/assets/Visa/dubai-banner.webp';
    }
}
</script>
