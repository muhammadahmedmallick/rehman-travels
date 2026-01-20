<template>
    <label class="flex">
        <img src="/calendar/calendar.svg" alt="calender" class="mr-1"/>
        <input type="text"
               v-on:keypress="isInteger"
               ref="initialInput"
               :value="modelValue"
               v-on:input="$emit('update:modelValue', $event.target.value)"
               :id="initialInput"
               required="required"
               autocomplete="off"
               readonly="readonly"
               class="w-full font-semibold lg:text-[14px] focus:outline-none border-none focus:ring-0 px-0"/>
    </label>
</template>
<script>
import moment from 'moment';
import Litepicker from "litepicker";
export default {
    name: "ChecInCheckOutDate",
    emits: ['update:modelValue', 'update:outinboundDateDetail'],
    components: {
        Litepicker
    },
    data(){
        return{
            isXlScreen: false,
        }
    },
    props: {
        modelValue: String,
        display: null,
        flightType: String,
        placeholder: {
            default: 'Search'
        },
        initialIndex: {
            type: Number
        },
        initialLastIndex: {
            type: Number
        },
        initialInput: {
            type: String
        }
    },
    watch: {
        modelValue(modelValue) {
            return this.setDateFormat(modelValue, 0);
        }
    },
    mounted() {
        this.isXlScreen = window.innerWidth <= 640;
        window.addEventListener('resize', this.handleResize);
        this.$nextTick(() => {
            if (this.$refs.initialInput !== null) {
                new Litepicker({
                    element: this.$refs.initialInput,
                    elementEnd: this.$refs.initialInput,
                    format: 'DD-MM-YYYY',
                    singleMode: (this.flightType === "round-trip" ? false : true),
                    minDate: new Date(moment().subtract(1, 'days').toDate()),
                    numberOfMonths: (this.isXlScreen  ? 18 : 2),
                    numberOfColumns: (this.isXlScreen  ? 1 : 2),
                    autoRefresh: false,
                    autoApply: false,
                    resetButton: false,
                    switchingMonths: 1,
                    position: 'right',
                    buttonText: {apply: 'Done'},
                    setup: (picker) => {
                        picker.on('show', () => {
                            if(this.isXlScreen){
                                document.body.style.position = "fixed";
                                document.body.style.overflow = "hidden";
                            }
                            if (this.flightType === "one-way") {
                               picker.clearSelection();
                            }
                            picker.gotoDate(new Date(moment().subtract(1, 'days').toDate()));
                        }),
                        picker.on('hide', () => {
                            document.body.style.overflow = "";
                            document.body.style.position = "";
                        }),
                        picker.on('selected', (start, end) => {
                            if (start !== null) {
                                if (this.flightType !== "round-trip") {
                                    this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
                                }
                                this.$emit('update:outinboundDateDetail', this.setInoutboundDate(start.dateInstance, (this.flightType === "round-trip" ? end.dateInstance : null), this.initialIndex));
                            }
                        }),
                        picker.on('button:apply', (start, end) => {
                            if (start !== null) {
                                if (this.flightType !== "round-trip") {
                                    this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
                                }
                                this.$emit('update:outinboundDateDetail', this.setInoutboundDate(start.dateInstance, (this.flightType === "round-trip" ? end.dateInstance : null), this.initialIndex));
                            }
                        });
                    }
                });
            }
        });
    },
    beforeDestroy() {
        window.removeEventListener('resize', this.handleResize);
    },
    methods: {
        handleResize() {
            this.isXlScreen = window.innerWidth <= 640;
        },
        isInteger(e) {
            e.preventDefault();
        },
        updateAutoOutinboundDate(initialDate) {
            let initialIndexs = (Number(this.initialLastIndex) - Number(this.initialIndex));
            let addDays = 0;
            for (let index = 0; index < initialIndexs; index++) {
                let initialIndex = Number(this.initialIndex) + Number(index);
                let outinboundDate = this.setDateFormat(initialDate, (initialIndex === 0 ? 0 : Number(addDays)));
                this.$emit('update:outinboundDateDetail', this.setInoutboundDate(outinboundDate, outinboundDate, initialIndex));
                addDays += 7;
            }
        },
        setInoutboundDate(start, end, initialIndex) {
            return JSON.parse(JSON.stringify({
                'initialDate': {
                    'start': this.setDateFormat(start, 0),
                    'end': (end !== null ? this.setDateFormat(end, 0) : '')
                },
                'initialIndex': initialIndex
            }))
        },
        setDateFormat(initialDate, days) {
            return moment((initialDate !== null ? initialDate : new Date()), "DD-MM-YYYY").add(days, 'day').format("DD-MM-YYYY");
        },
    },
};
</script>

<style>
@media (min-width: 641px) { 
    .litepicker{
        left: calc(23% - 100px) !important;
    }
}
@media (min-width: 768px) { 
    .litepicker{
        left: 23px !important;
    }
 }
 @media (min-width: 1024px) { 
    .litepicker {
        left: 126px !important;

    }
  }

  @media (min-width: 1280px) { 
    .litepicker {
        left: 368px !important;

    }
 }
   @media (min-width: 1536px) { 
    .litepicker {
        left: 760px !important;
    }
 }
</style>