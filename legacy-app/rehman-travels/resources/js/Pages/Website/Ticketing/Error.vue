<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>
<template>
    <GuestLayout>
    <div class="container mt-5 pt-5">
        <div class="alert alert-danger text-center">
            <h2 class="display-3 text-red-600">An unexpected error has occurred. Please try again</h2>
            <p class="display-5 text-red-600">Oops! {{JSON.parse(errors)['error']}}.</p>
        </div>
    </div>
</GuestLayout>
</template>
<script>
export default {
    name: "AllowedOnlyValidInput",
    props:{
        errors:"",
    }
}
</script>

<style scoped>

</style>
