<template>
    <a v-if="diverting" class="fixwhatsapp-btn flex items-center justify-center shadow-[0_2px_5px_rgba(0_0_0_0.3)] rounded-lg 
    fixed bottom-[6.5rem] sm:bottom-[5.5rem] right-6 md:right-3 z-[11] h-12 w-56 md:h-[3.57rem] md:w-[18.57rem] text-white 
    font-bold bg-[#008A04]">
        Diverting Please Wait ........
    </a>
    <a v-if="!diverting" target="_blank" @click="whatsappContact()" class="fixwhatsapp-btn flex items-center justify-center shadow-[0_2px_5px_rgba(0_0_0_0.3)] fixed bottom-[6.5rem] sm:bottom-[5.5rem] right-6 md:right-3 z-[11] h-12 w-12 md:h-[3.57rem] md:w-[3.57rem] rounded-full bg-[#25D366] ">
        <i class="fa-brands fa-whatsapp"></i>
        <span class="absolute bg-red-600 text-red-100 px-2 py-1 text-xs font-bold rounded-full -top-3 -right-3">1</span>
    </a>
</template>
<script>
import Service from "@/Config/Service.js";
export default{
    name: 'Whatsapp',
    data(){
        return {
            diverting: false,
            form: {
                contents: {
                    message : "Whatsapp Button",
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
            this.diverting = true;
            Service.doFetchRequest("/whatsapp", '', this.form).then((data) => {
                console.log(data);
                if( data.phone == '03315551662'){
                    window.location.href = 'https://api.whatsapp.com/send?phone=03315551662&&text=For%20Tour%20Guide%20and%20Booking%2c%20please%20provide%20the%20following%20info%3b%0A%0AYour%20Name%3a%0ANo%20of%20Persons%3a%0ATour%20Date%3a%0ATour%20Destination%3a%0ADeparture%20City%3a%0ATotal%20Days%3a%0A%0A%0A'+ data.getreferalUrl;
                }else{
                    window.location.href = 'https://api.whatsapp.com/send?phone='+ data.phone +'&&text=Need%20some%20Help%20Regarding%20%20%20'+ data.getreferalUrl;
                }
                this.diverting = false;

            });
        }
    }
}
</script>