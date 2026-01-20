<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue";
</script>

<template>
    <GuestLayout>
        <section class="bg-gray-200">
            <div class="banner md:h-[275px] h-[170px]" :style="'background-image:url('+banner+')'">
                <h1 class="text-white text-lg  sm:text-[2rem] md:text-[2.5rem] font-bold drop-shadow-[2px_2px_2px_gray] capitalize text-center py-28 sm:px-24 ">
                    Best Umrah Packages</h1>
            </div>
            <!-- Card Design -->
            <div class="container my-12 mx-auto px-4 md:px-16">
                <div class="flex flex-wrap -mx-1 ">
                    <div v-for="(UmrahPackage, UmrahPackageIndex) in getallUmrah" :key="UmrahPackageIndex"
                        class="my-1 px-1 w-full sm:w-1/2 lg:my-4  lg:w-1/3 lg:px-3">
                        <a :href="UmrahPackage.urlLink" class="relative flex justify-center items-center">
                            <div class=" rounded-[10px] w-full hover:bg-white">
                                <img :alt="UmrahPackage.packageTitle"
                                    class="block sm:h-[26rem] w-full  hover:opacity-100 rounded-lg hover:rounded-[1rem] hover:p-[10px] ease-in-out duration-300  hover:ease-in-out hover:duration-300 border-white border-[1px]"
                                    src="#">
                            </div>
                            <div class="absolute">
                                <p class="text-white text-center justify-center font-bold text-[2rem] drop-shadow-[2px_2px_1px_black] capitalize">{{ UmrahPackage.packageTitle }}</p>
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
    name: 'getallUmrah',
    props: {
        getallUmrah: { type: Object }
    },
    data(){
        return {
            banner:"",
        }
    },
    mounted(){
       this.banner = '/assets/Umrah/economy-banner.jpg';
    }

}
</script>
