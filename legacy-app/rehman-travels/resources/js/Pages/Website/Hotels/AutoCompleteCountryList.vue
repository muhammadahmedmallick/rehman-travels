<template>
    <div class="relative flex w-full">
        <i class="fa-solid text-rGTBaseTextColor ml-2 mr-1 mt-[18px] fa-hotel md:pl-2"></i>
        <input  type="text" ref="input"
                :value="display"
                v-on:input="handleInputEvent"
                v-on:click="search"
                v-on:keydown.up="up"
                v-on:keydown.down="down"
                v-on:keydown.enter="enter"
                v-on:keypress="isString"
                autocomplete="off" placeholder="Country List"
               class="h-12 pt-3 rounded-md pl-2 outline-none cursor-text overflow-hidden whitespace-nowrap text-ellipsis disabled:placeholder:text-gray-500 placeholder:text-[13px] placeholder:text-blue-gray-500 text-left text-[15px] font-semibold bg-white w-full border-0 focus:border-0 ring-0 focus:ring-0"/>
        <div v-if="showOptions && results.length > 0" class="absolute z-10 w-full bg-white border border-black rounded-md max-h-[15rem] min-h-[37px] overflow-y-auto pt-2 px-2 text-sm font-semibold right-0 mt-14 scrollbar-hidden">
            <ul>
                <li v-for="(result, resultKey) in results" :key="result[filterby]"
                    :class="`${(selectedIndex === resultKey ? 'selected' : (resultKey === 0 ? 'selected' : ''))} group hover:bg-bgRGTBaseColor hover:text-white rounded-md p-2 text truncate w-full cursor-pointer`"
                    v-on:click="isSelect(resultKey)">
                    <i :class="`${(selectedIndex === resultKey ? 'selected' : (resultKey === 0 ? 'selected' : ''))}  group-hover:bg-bgRGTBaseColor group-hover:text-white fa fa-plane text-[#0181dd]`">&nbsp;</i>
                    <span class="text-[14px] font-normal  group-hover:bg-bgRGTBaseColor group-hover:text-white" v-html="highlightMatchWord(result, resultKey)"></span>
                </li>
            </ul>
        </div>
    </div>
</template>

<script>
import hotels from "./hotels";

export default {
    emits: ['update:modelValue', 'update:arabianOryx'],
    props: {
        modelValue: String,
        modelModifiers: "",
        placeholder: { default: 'Search' },
        initialIndex: { type: Number },
        initialType:String,
        initialInput: { type: String, display: null }
    },
    data() {
        return {
            filterby: "fullName",
            display: this.modelValue || "",
            selectedItem: null,
            selectedIndex: null,
            loading: false,
            hotels: hotels,
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
                return [];
            }
            const displayResultSectors = this.display.trim().toUpperCase();
            let filterby = "fullName";
            if (displayResultSectors.length === 1 || displayResultSectors.length === 2) {
                filterby = "code" && "city";
            } else if (displayResultSectors.length === 3) {
                filterby = "code" && "fullName";
            }
            const matchingCodeResults = this.hotels.filter((hotel) => {
                const sectorValue = hotel[filterby].toUpperCase();
                return sectorValue.includes(displayResultSectors);
            });
            const matchingCodeResultsSorted = matchingCodeResults.sort((a, b) => {
                if (a.code.toUpperCase() === displayResultSectors) {
                    return -1;
                } else if (b.code.toUpperCase() === displayResultSectors) {
                    return 1;
                }
                return a[filterby].localeCompare(b[filterby]);
            });
            return matchingCodeResultsSorted;
        }
    },

    methods: {
        isString(e) {
            let selectedCharCode = String.fromCharCode(e.keyCode);
            if(/^[A-Za-z ]+$/.test(selectedCharCode)) return true;
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
            this.isSetSelected();
            if (this.display.length > 3) {
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
            this.$emit('update:arabianOryx', JSON.parse(JSON.stringify({ 'initialItem': this.selectedItem, 'initialIndex': this.initialIndex,'initialType':this.initialType })));
        },
        handleInputEvent(event) {
            this.display = event.target.value;
            this.selectedIndex = null;
            this.showOptions = true;
        },
        highlightMatchWord(result, resultKey) {
            const displayResultSectors = this.display.trim().toUpperCase();
            const filterby = "fullName";
            let matchedInputTextWithThisSector = result[filterby];
            if (result.code.toUpperCase() === displayResultSectors) {
                matchedInputTextWithThisSector = matchedInputTextWithThisSector.replace(
                    new RegExp(`(${displayResultSectors})`, "gi"),
                    '<span>$1</span>'
                );
            } else if (matchedInputTextWithThisSector.toLowerCase().includes(displayResultSectors.toLowerCase())) {
                const regex = new RegExp(`(${displayResultSectors})`, "gi");
                matchedInputTextWithThisSector = matchedInputTextWithThisSector.replace(
                    regex,
                    '<span style="font-weight: bold">$1</span>'
                );
            }
            return matchedInputTextWithThisSector;
        }
    }
};
</script>