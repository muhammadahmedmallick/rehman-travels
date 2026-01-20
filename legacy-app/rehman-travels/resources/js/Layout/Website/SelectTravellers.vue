<template>
    <div class="relative flex items-center text-[14px] cursor-pointer" v-on:click="toggleTravelers(displayType)">
        {{ `${travellers.totalTraveller} Traveller` }}
        <div
            :class="`${displayType} absolute top-10 left-0 sm:-left-[5.75rem] md:-left-0 md:top-8  bg-white text-black border w-56 p-2 rounded-xl shadow-[-2px_-4px_8px_-2px_#cdcdcd] z-20`">
            <div class="flex justify-between py-2">
                <div class="flex items-center">
                    <img :src="`/travellers/traveller.svg`" class="mr-2"/>
                    <span class="flex flex-col">Adult
            <span class="text-xs">(over 12 years)</span>
          </span>
                </div>
                <div class="flex items-center">
                    <button v-on:click="decreaseTravellers('adult')" :disabled="travellers.adultsCount === 1">
                        <img :src="`/travellers/minus.svg`"/>
                    </button>
                    <span class="mx-2">{{ travellers.adultsCount }}</span>
                    <button v-on:click="increaseTravellers('adult')" :disabled="sumTravellers >= 9">
                        <img :src="`/travellers/plus.svg`"/>
                    </button>
                </div>
            </div>
            <div class="flex justify-between py-2">
                <div class="flex items-center">
                    <img :src="`/travellers/child.svg`" class="mr-2"/>
                    <span class="flex flex-col">
            Child
            <span class="text-xs">(under 2-11 years)</span>
          </span>
                </div>
                <div class="flex items-center">
                    <button v-on:click="decreaseTravellers('child')" :disabled="travellers.childrenCount === 0">
                        <img :src="`/travellers/minus.svg`"/>
                    </button>
                    <span class="mx-2">{{ travellers.childrenCount }}</span>
                    <button v-on:click="increaseTravellers('child')" :disabled="sumTravellers >= 9">
                        <img :src="`/travellers/plus.svg`"/>
                    </button>
                </div>
            </div>
            <div class="flex justify-between py-2">
                <div class="flex items-center">
                    <img :src="`/travellers/infant.svg`" class="mr-2"/>
                    <span class="flex flex-col">
            Infant
            <span class="text-xs">(under 2 years)</span>
          </span>
                </div>
                <div class="flex items-center">
                    <button v-on:click="decreaseTravellers('infant')" :disabled="travellers.infantsCount === 0">
                        <img :src="`/travellers/minus.svg`"/>
                    </button>
                    <span class="mx-2">{{ travellers.infantsCount }}</span>
                    <button v-on:click="increaseTravellers('infant')" :disabled="sumTravellers >= 9">
                        <img :src="`/travellers/plus.svg`"/>
                    </button>
                </div>
            </div>
            <div class="flex justify-center">
                <button v-on:click="doneTravellers()" class="bg-[#0d6efd] text-white text-md font-semibold py-1 mt-3 rounded-full w-1/2">Done</button>
            </div>
        </div>
    </div>
</template>

<script>
import {mapState} from "vuex";

export default {
    emits: ["selectedTravelers"],
    data() {
        return {
            displayType: 'hidden',
            travellers: {
                adultsCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.adultsCount : 1),
                childrenCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.childrenCount : 0),
                infantsCount: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.infantsCount : 0),
                totalTraveller: (this.$store.state.flightTravelers !== "" ? this.$store.state.flightTravelers.totalTraveller : 1)
            }
        };
    },
    computed: {
        ...mapState(['flightTravelers']),
        sumTravellers() {
            this.travellers.totalTraveller = this.travellers.adultsCount + this.travellers.childrenCount + this.travellers.infantsCount;
            this.$emit('selectedTravelers', {
                'adultsCount': this.travellers.adultsCount,
                'childrenCount': this.travellers.childrenCount,
                'infantsCount': this.travellers.infantsCount,
                'totalTraveller': this.travellers.totalTraveller
            });
            return this.travellers.totalTraveller
        },
    },
    mounted () {
        document.addEventListener('click', this.close);
    },
    beforeDestroy () {
        document.removeEventListener('click',this.close)
    },
    methods: {
        toggleTravelers(displayType) {
            this.displayType = (displayType == "hidden" ? "block" : "hidden")
        },
        increaseTravellers(type) {
            if (
                (type === "adult" && this.travellers.adultsCount < 9 && this.travellers.totalTraveller < 9) ||
                (type === "child" && this.travellers.childrenCount < 6 && this.travellers.totalTraveller < 9) ||
                (type === "infant" && this.travellers.infantsCount < 2 && this.travellers.totalTraveller < 9)
            ) {
                if (type === "adult") {
                    this.travellers.adultsCount++;
                } else if (type === "child") {
                    this.travellers.childrenCount++;
                } else if (type === "infant") {
                    this.travellers.infantsCount++;
                }
            }
            this.displayType = "hidden"
        },
        decreaseTravellers(type) {
            if (
                (type === "adult" && this.travellers.adultsCount > 1) ||
                (type === "child" && this.travellers.childrenCount > 0) ||
                (type === "infant" && this.travellers.infantsCount > 0)
            ) {
                if (type === "adult") {
                    this.travellers.adultsCount--;
                } else if (type === "child") {
                    this.travellers.childrenCount--;
                } else if (type === "infant") {
                    this.travellers.infantsCount--;
                }
            }
            this.displayType = "hidden"
        },
        doneTravellers() {
            this.travellers.totalTraveller = this.travellers.adultsCount + this.travellers.childrenCount + this.travellers.infantsCount;
            this.$emit('selectedTravelers', this.travellers);
            this.displayType = "block"
        },
        close (e) {
            if (!this.$el.contains(e.target)) {
                this.displayType = 'hidden';
            }
        },
    },
};
</script>
