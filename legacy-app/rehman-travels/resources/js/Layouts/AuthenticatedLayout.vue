<script setup>
import { ref } from 'vue';
import HeaderLayout from "@/Layout/Backend/HeaderLayout.vue";
import FooterLayout from "@/Layout/Backend/FooterLayout.vue";
</script>
<template>
    <div>
        <div class="min-h-screen bg-gray-100">
            <!-- Page Heading -->
            <HeaderLayout/>
            <!-- Page Content -->
            <main>
                <slot />
            </main>
            <!-- Page Footer -->
            <FooterLayout/>
        </div>
    </div>
</template>
