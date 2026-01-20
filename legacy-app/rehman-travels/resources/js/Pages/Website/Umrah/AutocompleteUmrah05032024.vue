<template>
    <div class="relative flex w-full border border-gray-300 hover:border-gray-400 rounded">
        <input  type="text" ref="input"
                :value="display"
                v-on:input="handleInputEvent"
                v-on:focus="handleInputEvent"
                v-on:click="search"
                v-on:keydown.up="up"
                v-on:keydown.down="down"
                v-on:keydown.enter="enter"
                v-on:keypress="isString"
                autocomplete="off" placeholder="Hotel Name?"
               class="text-sm block w-full h-[2.68rem]  text-gray-700 border-0 focus:ring-0 hover:border-gray-400 pr-7 pl-3  rounded leading-tight focus:outline-none focus:bg-white focus:border-blue-500"/>
        <div v-if="showOptions && results.length > 0" class="absolute z-10 w-full bg-white border border-black rounded-md max-h-[15rem] min-h-[37px]  overflow-y-auto pt-2 px-2 text-sm font-semibold right-0 mt-14 scrollbar-hidden">
            <ul>
                <li v-for="(result, resultKey) in results" :key="result[this.filterby]"
                    :class="`${(selectedIndex === resultKey ? 'selected' : (resultKey === 0 ? 'selected' : ''))} hover:bg-[#0181dd] hover:text-[#fff] rounded-md p-2 text truncate w-full cursor-pointer`"
                    v-on:click="isSelect(resultKey)">
                    <i :class="`${(selectedIndex === resultKey ? 'selected' : (resultKey === 0 ? 'selected' : ''))} fa fa-hotel text-[#0181dd]`">&nbsp;</i>
                    <span class="text-[14px] font-normal" v-html="highlightMatchWord(result, resultKey)"></span>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>

export default {
    emits: ['update:modelValue', 'umrahSelectedHotels'],
    props: {
        modelValue: String,
        modelModifiers: "",
        umrahHotels : { type : Array},
        placeholder: { default: 'Search' },
        initialIndex: { type: Number },
        initialType:String,
    },
    data() {
        return {
            filterby: "umrahHotels",
            display: this.modelValue || "",
            selectedItem: null,
            selectedIndex: null,
            loading: false,
            showOptions: false
        };
    },
    watch: {
        modelValue(modelValue) {
            this.display = modelValue;
        }
    },
    computed: {
        results() {
            if (!this.display) {
                this.umrahHotels.filter((hotel) => {
                    if(hotel.length < 8){
                        const hotelValue = hotel.hotelName.toUpperCase();
                        return hotelValue;
                    }
                });
            }
            const displayResultHotels = this.display.trim().toUpperCase();
            const matchingResults = this.umrahHotels.filter((hotel) => {
                const hotelValue = hotel.hotelName.toUpperCase();
                return hotelValue.includes(displayResultHotels);
            });
            const matchingResultsSorted = matchingResults.sort((a, b) => {
                if (a.hotelName.includes(displayResultHotels)) {
                    return -1;
                } else if (b.hotelName.includes(displayResultHotels)) {
                    return 1;
                }
                return a.hotelName.localeCompare(b.hotelName);
            });
            return matchingResultsSorted;
        }
    },

    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z]+$/.test(selectedCharCode)) return true;
            else e.preventDefault();
        },
        search(event) {
            event.target.select();
            this.isVisible = true;
            setTimeout(() => {
                this.$refs.input.focus();
            }, 10);
        },
        isSelect(resultKey) {
            this.selectedIndex = resultKey;
            if (this.selectedIndex === null) {
                if (this.results.length > 0) {
                    this.selectedIndex = 0;
                    this.isSetSelected();
                    this.emitIsSetSelected();
                }
            } else {
                this.isSetSelected();
                this.emitIsSetSelected();
            }
            this.showOptions = false;
        },
        isSetSelected() {
            this.selectedItem = this.results[this.selectedIndex];
            this.display = this.selectedItem[this.filterby];
            this.value = this.display;
            this.isVisible = false;
        },
        down() {
            if (this.selectedIndex === null) {
                this.selectedIndex = 0;
                return;
            }
            this.selectedIndex = (this.selectedIndex === this.results.length - 1) ? 0 : this.selectedIndex + 1;
        },
        up() {
            if (this.selectedIndex === null) {
                this.selectedIndex = this.results.length - 1;
                return;
            }
            this.selectedIndex = (this.selectedIndex === 0) ? this.results.length - 1 : this.selectedIndex - 1;
        },
        enter() {
            if (this.selectedIndex === null) {
                if (this.results.length > 0) {
                    this.selectedIndex = 0;
                    this.isSetSelected();
                    this.emitIsSetSelected();
                }
            } else {
                this.isSetSelected();
                this.emitIsSetSelected();
            }
            this.showOptions = false;
        },
        emitIsSetSelected(){
            this.$emit('umrahSelectedHotels', JSON.parse(JSON.stringify({ 'initialItem': this.selectedItem, 'initialIndex': this.initialIndex })));
        },
        handleInputEvent(event) {
            this.display = event.target.value;
            this.selectedIndex = null;
            this.showOptions = true;
        },
        highlightMatchWord(result, resultKey) {
            const displayResultHotels = this.display.trim().toUpperCase();
            let matchedInputTextWithThisHotel = result.hotelName;
            if (result.hotelName.toUpperCase() === displayResultHotels) {
                matchedInputTextWithThisHotel = matchedInputTextWithThisHotel.replace(
                    new RegExp(`(${displayResultHotels})`, "gi"),
                    '<span>$1</span>'
                );
            } else if (matchedInputTextWithThisHotel.toLowerCase().includes(displayResultHotels.toLowerCase())) {
                const regex = new RegExp(`(${displayResultHotels})`, "gi");
                matchedInputTextWithThisHotel = matchedInputTextWithThisHotel.replace(
                    regex,
                    '<span style="color: #0181dd;font-weight: bold">$1</span>'
                );
            }
            return matchedInputTextWithThisHotel;
        }
    }
};
</script>