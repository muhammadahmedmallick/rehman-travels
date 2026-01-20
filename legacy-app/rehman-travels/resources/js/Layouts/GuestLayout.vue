<script setup>
import HeaderLayout from "@/Layout/Website/HeaderLayout.vue";
import FooterLayout from '@/Layout/Website/FooterLayout.vue';
import ScrollToTopBtn from "@/Pages/Website/Common/ScrollToTopBtn.vue";
import WhatsupButton from "@/Pages/Website/Common/WhatsupButton.vue";
import CallBackForm from "@/Pages/Website/Common/CallBackForm.vue";
</script>
<template>
    <HeaderLayout />
    <div>
        <main>
            <slot/>
        </main>
    </div>
    <ScrollToTopBtn />
    <CallBackForm></CallBackForm>
    <WhatsupButton v-if="$page.props.getNum.whatsapp !== ''" />
    <FooterLayout/>
</template>