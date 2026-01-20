<template>
    <div class="py-1 mr-2 relative flex items-center text-[14px] focus:outline-none cursor-pointer" v-on:click="flightClassCabin(displayType)">
            {{ selectedClassCabin || "Class Cabin" }}
            <ul  :class="`${displayType} absolute top-7 -left-2 md:-left-0 md:top-7  w-44 p-2 bg-white text-black border rounded-lg shadow-md z-20`">
                <li v-for="(cabin,cabinKey) in cabins" :key="cabinKey">
                    <a class="flex items-center p-2 hover:bg-[#e7e7e7] rounded-md duration-300"
                       v-on:click="selectCabin(cabin)">
                        {{ cabin.name }}
                    </a>
                </li>
            </ul>
    </div>
</template>
<script>
import {mapState} from "vuex";
export default {
    emits: ["selectedCabin"],
    computed: {...mapState(['flightCabin'])},
    data() {
        return {
            displayType:'hidden',
            selectedClassCabin: (this.$store.state.flightCabin !== "" ? this.$store.state.flightCabin.name: 'Economy'),
            cabins: [
                {name: "Economy", cabin: "Y"},
                {name: "Premium Economy",cabin: "S"},
                {name: "Business Class",cabin: "C"},
                {name: "First Class", cabin: "F"},
            ],
        };
    },
    mounted() {
        document.addEventListener('click', this.close);
    },
    beforeDestroy() {
        document.removeEventListener('click', this.close);
    },
    methods: {
        flightClassCabin(displayType) {
            this.displayType =(displayType == "hidden" ? "block" :  "hidden")
        },
        selectCabin(classCabin) {
            this.selectedClassCabin = classCabin.name;
            this.$emit('selectedCabin',classCabin)
        },
        close (e) {
            if (!this.$el.contains(e.target)) {
                this.displayType = 'hidden';
            }
        },
    },
};
</script>
