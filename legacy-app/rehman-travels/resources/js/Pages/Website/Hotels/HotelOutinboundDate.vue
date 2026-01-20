<template>
    <label class="flex relative text-center align-middle">
        <img src="/calendar/calendar.svg" alt="calender" class="mr-1"/>
        <input type="text"
           v-on:keypress="isInteger"
           ref="initialInput"
           :value="(modelValue != '' ? modelValue : '' )"
           v-on:input="$emit('update:modelValue', $event.target.value)"
           :id="initialInput"
           required="required"
           autocomplete="off"
           readonly="readonly"
           placeholder=""
           class="peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-0"
        />
        <label class="flex w-full h-full select-none pointer-events-none absolute left-2 font-medium !overflow-visible truncate peer-placeholder-shown:text-blue-gray-500 leading-tight peer-focus:leading-tight peer-disabled:text-transparent peer-disabled:peer-placeholder-shown:text-gray-500 transition-all -top-1.5 peer-placeholder-shown:text-sm text-[11px] peer-focus:text-[11px] before:content[' '] before:block before:w-2.5 before:h-1.5 before:mt-[6.5px] before:mr-1 before:rounded-tl-md before:pointer-events-none before:transition-all after:content[' '] after:block after:flex-grow after:w-2.5 after:h-1.5 after:mt-[6.5px] after:ml-1 after:pointer-events-none after:transition-all peer-placeholder-shown:leading-[3.75] text-gray-500 peer-focus:text-gray-900">
            {{ initialInput == 'checkIn' ? 'Check In' : (flightType === 'round-trip' ? 'Check Out' : 'Check In') }}
        </label>
    </label>
</template>
<script>
import moment from 'moment';
import Litepicker from "litepicker";
export default {
    name: "OutinboundDate",
    emits: ['update:modelValue', 'update:outinboundDateDetail'],
    components: {
        Litepicker
    },
    data(){
        return{
            isXlScreen: false,
            bodyScroll: false,
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
                    autoRefresh: true,
                    autoApply: false,
                    resetButton: false,
                    position: 'right',
                    buttonText: {apply: 'Done'},
                    setup: (picker) => {
                        picker.on('selected', (start, end) => {
                            if (start !== null) {
                                if (this.flightType !== "round-trip") {
                                    this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
                                }
                                this.$emit('update:outinboundDateDetail', this.setInoutboundDate(start.dateInstance, (this.flightType === "round-trip" ? end.dateInstance : null), this.initialIndex));
                            }
                        }),
                        picker.on('show', (start, end) => {
                            if(this.isXlScreen){
                                document.body.style.overflow = "hidden";
                                document.body.style.position = "fixed";
                            }
                            
                            // if (this.flightType === "one-way") {
                            //   picker.clearSelection();
                            // }
                            picker.gotoDate(new Date(moment().subtract(1, 'days').toDate()));
                        }),
                        picker.on('hide', (start, end) => {
                            document.body.style.overflow = "";
                            document.body.style.position = "";
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