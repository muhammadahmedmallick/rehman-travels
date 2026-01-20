<template>
    <div class="py-1 mr-2 relative flex items-center text-[14px] focus:outline-none cursor-pointer" v-on:click="flightStop(displayType)">

        {{ selectedStop || "Stop's" }}
        <ul  :class="`${displayType} absolute top-7 -left-2 md:-left-0 md:top-7  w-44 p-2 bg-white text-black border rounded-lg shadow-md z-20`">
            <li v-for="(stop,stopKey) in stops" :key="stopKey">
                <a class="flex items-center p-2 hover:bg-[#e7e7e7] rounded-md duration-300"
                   v-on:click="selectStop(stop)">
                    {{ (stop.value !== 0 ? stop.value : '') }} {{ stop.name }}
                </a>
            </li>
        </ul>
    </div>
</template>
<script>
import {mapState} from "vuex";

export default {
    emits: ["selectedStop"],
    computed: {...mapState(['flightStops'])},
    data() {
        return {
            displayType: 'hidden',
            selectedStop: this.isSelectedStop(),
            stops: [
                {value: '', name: "Stop's"},
                {value: 0, name: "Direct"},
                {value: 1, name: "Stop"},
                {value: 2, name: "Stops"},
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
        isSelectedStop(){
            if(typeof this.$store.state.flightStop === 'object' && this.$store.state.flightStop !== null){
                return `${(this.$store.state.flightStop.value !== 0 ? this.$store.state.flightStop.value :'')} ${this.$store.state.flightStop.name}`;
            }
        },
        flightStop(displayType) {
            this.displayType = (displayType === "hidden" ? "block" : "hidden")
        },
        selectStop(stop) {
            this.selectedStop = stop.value === 0 ? 'Direct' : stop.value === 1 ? '1 Stop' : stop.value + ' Stops';
            this.$emit('selectedStop', stop)
        },
        close(e) {
            if (!this.$el.contains(e.target)) {
                this.displayType = 'hidden';
            }
        },
    },
};
</script>
