<template>
    <div class="relative flex w-full">
        <i :class="iconClasses" class="fa-solid text-rGTBaseTextColor ml-2 mr-1 mt-[18px]"></i>
        <input
            ref="input"
            type="text"
            :value="query"
            @input="handleInputEvent"
            @keydown.down.prevent="down"
            @keydown.up.prevent="up"
            @keydown.enter.prevent="enter"
            @click="clearInput"
            @keypress="validateCharacter"
            autocomplete="off"
            :placeholder="inputPlaceholder"
            class="h-12 pt-4 rounded-md px-4 pr-14 outline-none cursor-text overflow-hidden whitespace-nowrap text-ellipsis text-left text-[15px] font-semibold bg-white w-full border-0 focus:border-0 ring-0 focus:ring-0"
        />
        <button v-if="query" type="button"
            class="absolute bg-transparent right-4 top-1/2 transform -translate-y-1/2 text-red-600 hover:text-red-600 focus:outline-none font-bold hover:font-bold rounded-lg p-1 flex items-center justify-center w-6 h-6"
            aria-label="Clear input"
            @click="clearInput">X</button>
        <ul v-if="showDropdown && airports.length"
            class="absolute z-10 w-full bg-white border border-black rounded-md max-h-[15rem] min-h-[37px] overflow-y-auto pt-2 px-2 text-sm font-semibold right-0 mt-14 scrollbar-hidden">
            <li v-for="(airport, index) in airports"
                :key="airport.id"
                @click="selectAirport(index)"
                :class="[
          'p-2 cursor-pointer',
          selectedIndex === index ? 'bg-blue-200' : '',
          isExactCodeMatch(airport) ? 'bg-blue-100 font-semibold' : '',
        ]">
        <span class="text-[13px] font-normal group-hover:bg-bgRGTBaseColor group-hover:text-white"
              v-html="highlightMatch(fullAirportText(airport))"></span>
            </li>
        </ul>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    emits: ['update:modelValue', 'update:autocomplete'],
    props: {
        modelValue: String,
        initialType: {type: String, default: 'outbound'},
        initialIndex: Number,
    },
    data() {
        return {
            query: this.modelValue || '',
            airports: [],
            selectedIndex: -1,
            showDropdown: false,
        };
    },
    watch: {
        modelValue(newValue) {
            this.query = newValue;
        },
    },
    computed: {
        inputPlaceholder() {
            return this.initialType === 'outbound' ? 'From Where' : 'To Where';
        },
        iconClasses() {
            const direction = this.initialType === 'outbound' ? 'departure' : 'arrival';
            const padding = this.initialType === 'inbound' ? 'md:pl-2' : 'md:pl-0';
            return `fa-plane-${direction} ${padding}`;
        },
    },
    methods: {
        clearInput() {
            this.query = '';
            this.selectedIndex = -1;
            this.airports = [];
            this.showDropdown = false;
        },
        handleInputEvent(e) {
            this.query = e.target.value;
            this.search();
        },
        async search() {
            if (this.query.length <= 2) {
                this.resetDropdown();
                return;
            }
            try {
                const response = await axios.get(`/ticketing/cheapest-fare-airports?query=${this.query}`);
                this.airports = response.data;
                this.showDropdown = true;
                this.selectedIndex = this.airports.length ? 0 : -1;
                this.scrollToSelected();
            } catch (error) {
                this.resetDropdown();
                console.warn('Could not fetch airports.');
            }
        },
        resetDropdown() {
            this.airports = [];
            this.showDropdown = false;
            this.selectedIndex = -1;
        },
        up() {
            if (this.selectedIndex > 0) {
                this.selectedIndex--;
                this.scrollToSelected();
            }
        },
        down() {
            if (this.selectedIndex < this.airports.length - 1) {
                this.selectedIndex++;
                this.scrollToSelected();
            }
        },
        enter() {
            if (this.selectedIndex >= 0) {
                this.selectAirport(this.selectedIndex);
            }
        },
        validateCharacter(e) {
            const char = String.fromCharCode(e.keyCode);
            if (!/^[A-Za-z ]$/.test(char)) e.preventDefault();
        },
        selectAirport(index) {
            const airport = this.airports[index];
            const formattedAirport = {
                code: airport.code,
                airport: `${airport.code} - ${airport.airport}, ${airport.country}`,
                city: airport.city,
                country: airport.country,
                sectorType: airport.sectorType,
                fullName: `${airport.code} - ${airport.airport}, ${airport.country}`,
                index: this.initialIndex,
                initialType: this.initialType,
            };

            this.$emit('update:autocomplete', formattedAirport);
            this.query = this.fullAirportText(airport);
            this.resetDropdown();
        },
        highlightMatch(text) {
            const search = this.query.trim();
            if (!search) return text;
            const escaped = search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            const regex = new RegExp(`(${escaped})`, 'ig');
            return text.replace(regex, '<mark>$1</mark>');
        },
        fullAirportText(airport) {
            return `${airport.code} - ${airport.airport}, ${airport.city}, ${airport.country}`;
        },
        scrollToSelected() {
            this.$nextTick(() => {
                const items = this.$el.querySelectorAll('ul li');
                const item = items[this.selectedIndex];
                if (item) item.scrollIntoView({block: 'nearest'});
            });
        },
        isExactCodeMatch(airport) {
            return airport.code.toLowerCase() === this.query.trim().toLowerCase();
        },
    },
};
</script>

<style scoped>
.input {
    width: 100%;
    padding: 12px;
    font-size: 16px;
}

.dropdown {
    position: absolute;
    width: 100%;
    background: white;
    border: 1px solid #ccc;
    z-index: 100;
    max-height: 200px;
    overflow-y: auto;
}

mark {
    background-color: #ffe58f;
}
</style>
