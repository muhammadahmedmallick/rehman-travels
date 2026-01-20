<script setup>
import NavLink from '@/Components/NavLink.vue';
</script>
<template>
    <div class="hidden space-x-8 sm:-my-px sm:ml-10 sm:flex">
        <NavLink :href="route('dashboard')" :active="route().current('dashboard')" class="custom-nav-links text-black">Dashboard</NavLink>
        <NavLink onclick={showingNavigationDropdown} class="text-black font-semibold">Umrah</NavLink>
        <NavLink :href="route('umrah.hotel')" class="text-black font-semibold">Hotels</NavLink>
        <NavLink :href="route('umrah.visas')" class="text-black font-semibold">Umrah Visa</NavLink>
        <NavLink :href="route('umrah.vehicle-sector-price')" class="text-black font-semibold">Transport-Sector Price</NavLink>
    </div>
</template>
<script>
export default {
    name: "TopNav",
    props: {
        showingNavigationDropdown: false,
    }
}
</script>
