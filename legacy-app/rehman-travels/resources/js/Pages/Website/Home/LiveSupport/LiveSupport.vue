<template>
  <div
    class="flex justify-center bg-[#d6e4f1] p-3 md:-mt-[8rem] -mt-48"
  >
    <section class="grid grid-cols-12">
      <div class="col-span-12 md:col-span-4 px-3 mb-4 md:mb-0 flex items-center justify-center md:justify-end text-[#000000D9]" >
        <img src="common/liveSupport.webp" alt="Rehman Travel Support" width="66px" height="67px" class="mr-2 w-[20%] sm:w-[17%] md:w-[20%] rounded-[50%] border border-1 border-gray-300" />

        <div>
          <p class="font-semibold lg:text-xl md:text-lg">
            24/7 Hours Support
          </p>
          <p class="text-[13px] md:text-[14px] lg:text-[16px] ">Speak to our Travel Expert</p>
        </div>
      </div>

      <div class="col-span-12 md:col-span-8 px-3 text-[#08437D] flex items-center justify-center md:justify-start">
        <div class="flex justify-center items-center">
          <div class="grid grid-cols-12">
            <div class="col-span-12 md:col-span-4">
              <div class="flex items-center mt-1 xxs:mt-0">
                <span class="rounded-full bg-[#25D366] p-[0px_4px_0px_4px] items-center">
                  <i class="fa-brands fa-whatsapp text-white text-2xl"></i>
                </span>&nbsp;
                <p class="lg:text-base xl:text-lg text-[14px] font-bold underline cursor-pointer">
                  <a target="_blank" @click="whatsappContact()">{{ $page.props.getNum.whatsapp }}</a>
                </p>
              </div>
            </div>
            <div class="col-span-12 sm:mt-0 mt-2 md:col-span-4">
              <div class="mr-2 flex items-center">
                <i class="fa fa-phone text-rGTBaseTextColor"></i>&nbsp;
                <p class="lg:text-base xl:text-lg text-[14px] font-bold underline">
                  <a target="_blank" :href="'tel:'+ $page.props.getNum.landline">{{ $page.props.getNum.landline }}</a>
                </p>
              </div>
            </div>
            <div class="col-span-12 sm:mt-0 mt-2 md:col-span-4">
              <div class="flex items-center mt-1 xxs:mt-0">
                <i class="fa fa-envelope text-rGTBaseTextColor mr-2 mt-[3px]"></i>
                <p class="lg:text-base xl:text-lg text-[14px] font-bold underline">
                  <a target="_blank" href="mailto:info@rehmantravel.com">info@rehmantravel.com</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import Service from "@/Config/Service.js";
export default{
    name: 'Live Support',
    data(){
        return {
            form: {
                contents: {
                    message : "Live Support Section",
                    moduleId : 19,
                    leadFrom : ""
                },
                whatsapp:{
                  code: (this.$page.props.getNum !== '' ? this.$page.props.getNum.country_code2 : 'PK')
                }
            },
        }
    },
    methods: {
        whatsappContact(){
            Service.doFetchRequest("/whatsapp", '', this.form).then((data) => {
                console.log(data);
                window.location.href = 'https://api.whatsapp.com/send?phone='+ data.phone +'&&text=Need%20some%20Help%20Regarding%20%20%20'+ data.getreferalUrl;
            });
        }
    }
}
</script>