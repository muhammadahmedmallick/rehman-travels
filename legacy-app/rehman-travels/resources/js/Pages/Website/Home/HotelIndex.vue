<script setup>
import GuestLayout from "@/Layouts/GuestLayout.vue"
</script>
<template>
    <GuestLayout>
        <SearchHotel/>
        <div class="-mt-32">
            <Introduction/>
            <SubscribeSection />
        </div>
    </GuestLayout>
</template>
<script>
import SearchHotel from '@/Layout/Website/SearchHotel.vue';
import SubscribeSection from '@/Layout/SubscribeSection.vue';
import Introduction from "@/Pages/Website/Common/Introduction/TheIntroduction.vue";
import LiveSupport from "@/Pages/Website/Home/LiveSupport/LiveSupport.vue"
export default {
    name: 'Home',
    components: {
        SearchHotel,
        Introduction,
        LiveSupport,
        SubscribeSection
    },
    data() {
        return {
            selectedOption: "Round-Trip",
            fromWhereInput: '',
            toWhereInput: '',
            fromDate: "",
            toDate: "",
            minToDate: "",
            fromWhere: "",
            toWhere: "",
            enteredFromDate: "",
            enteredToDate: "",
            entries: [
                { fromWhere: "", toWhere: "", enteredFromDate: "", enteredToDate: "" },
            ],
        };
    },
    methods: {
        updateMinToDate() {
            this.minToDate = this.fromDate;
            if (this.toDate < this.fromDate) {
                this.toDate = this.fromDate;
            }
        },
        addNewEntry() {
            this.entries.push({
                fromWhere: "",
                toWhere: "",
                enteredFromDate: "",
                enteredToDate: "",
            });
        },
        removeLastEntry() {
            this.entries.pop();
        },
        swapBtn() {
            const temp = this.fromWhereInput;
            this.fromWhereInput = this.toWhereInput;
            this.toWhereInput = temp;
        },
    }
}
</script>