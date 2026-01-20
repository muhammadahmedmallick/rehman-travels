<template>
    <div v-for="(visa, visaIndex) in $page.props.visaPackages" :key="visaIndex">
        <div v-for="(visitVisa, visitVisaIndex) in visa.visitVisas" class="w-full p-3 border border-gray-500 bg-white rounded mb-3">
            <a class="items-center inline-flex" :href="baseUrl +'/'+ visa.visitVisas[visitVisaIndex].content_pages.urlLink">
                <img :src="`/assets/flags/${visitVisa.countryName}-flag.webp`"> &nbsp;
                <p class="text-lg font-semibold">{{ visitVisa.countryName }} Visit Visa</p>
            </a>
        </div>
    </div>
</template>

<script>
export default{
  data(){
    return {
      baseUrl: '',
    }
  },
  mounted(){
    this.baseUrl = this.$page.props.ziggy.url;
  }
}
</script>