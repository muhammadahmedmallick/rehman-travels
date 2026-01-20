<script setup>
import ResponsiveNavLink from '@/Components/ResponsiveNavLink.vue';
</script>
<template>
    <nav class="bg-white border-b border-gray-100">
        <div :class="{ block: showingNavigationDropdown, hidden: !showingNavigationDropdown }" class="sm:hidden">
            <div class="pt-2 pb-3 space-y-1">
                <ResponsiveNavLink :href="route('dashboard')" :active="route().current('dashboard')">Dashboard</ResponsiveNavLink>
                <ResponsiveNavLink class="custom-nav-links" onclick={showingNavigationDropdown} >Umrah</ResponsiveNavLink>
                <ResponsiveNavLink :href="route('umrah.hotel')" >Hotels</ResponsiveNavLink>
                <ResponsiveNavLink :href="route('umrah.visas')" >Umrah Visa</ResponsiveNavLink>
                <ResponsiveNavLink :href="route('umrah.vehicle-sector-price')">Transport-Sector Price</ResponsiveNavLink>
            </div>
            <div class="pt-4 pb-1 border-t border-gray-200">
                <div class="px-4">
                    <div class="font-medium text-base text-gray-800">{{ $page.props.auth.user.name }}</div>
                    <div class="font-medium text-sm text-gray-500">{{ $page.props.auth.user.email }}</div>
                </div>
                <div class="mt-3 space-y-1">
                    <ResponsiveNavLink :href="route('profile.edit')"> Profile </ResponsiveNavLink>
                    <ResponsiveNavLink :href="route('logout')" method="post" as="button">Log Out</ResponsiveNavLink>
                </div>
            </div>
        </div>
    </nav>
</template>
<script>
export default {
    name: "ResponsiveNav",
    props:{
        showingNavigationDropdown:false,
    }
}
</script>
