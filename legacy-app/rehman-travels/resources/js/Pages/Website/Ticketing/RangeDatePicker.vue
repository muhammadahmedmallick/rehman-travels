<template>
    <div :class="`${(obdErrDate !== '' && obdDate === '') ? 'border-red-500 border-2' : 'border-gray-300'}  w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md  md:mr-0`">
        <label class="flex relative text-center align-middle">
            <img src="/calendar/calendar.svg" alt="calender" class="mr-1"/>
            <input type="text"
                   v-on:keypress="isInteger"
                   ref="initialStartInput"
                   :id="initialStartInput"
                   :value="(obdDate !== '' ? obdDate : '' )"
                   v-on:input="$emit('update:modelValue', $event.target.value)"
                   required="required"
                   autocomplete="off"
                   readonly="readonly"
                   placeholder=""
                   class="focus:bg-white focus:border-blue-500 peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-0"
            />
            <label
                class="flex w-full h-full select-none pointer-events-none absolute left-2 font-medium !overflow-visible truncate peer-placeholder-shown:text-blue-gray-500 leading-tight peer-focus:leading-tight peer-disabled:text-transparent peer-disabled:peer-placeholder-shown:text-gray-500 transition-all -top-1.5 peer-placeholder-shown:text-sm text-[11px] peer-focus:text-[11px] before:content[' '] before:block before:w-2.5 before:h-1.5 before:mt-[6.5px] before:mr-1 before:rounded-tl-md before:pointer-events-none before:transition-all after:content[' '] after:block after:flex-grow after:w-2.5 after:h-1.5 after:mt-[6.5px] after:ml-1 after:pointer-events-none after:transition-all peer-placeholder-shown:leading-[3.75] text-gray-500 peer-focus:text-gray-900">
                Departure
            </label>
        </label>
    </div>
    <div :class="`${(ibdErrDate !== '' && ibdDate === '') ? 'border-red-500 border-2' : 'border-gray-300'}   w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md md:mr-0`">
        <label class="flex relative text-center align-middle">
            <img src="/calendar/calendar.svg" alt="calender" class="mr-1"/>
            <input type="text"
                   ref="initialEndInput"
                   :id="this.initialEndInput"
                   :value="(ibdDate !== '' ? ibdDate : '' )"
                   v-on:input="$emit('update:modelValue', $event.target.value)"
                   required="required"
                   autocomplete="off"
                   readonly="readonly"
                   placeholder=""
                   class="focus:bg-white focus:border-blue-500 peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-0"
            />
            <label
                class="flex w-full h-full select-none pointer-events-none absolute left-2 font-medium !overflow-visible truncate peer-placeholder-shown:text-blue-gray-500 leading-tight peer-focus:leading-tight peer-disabled:text-transparent peer-disabled:peer-placeholder-shown:text-gray-500 transition-all -top-1.5 peer-placeholder-shown:text-sm text-[11px] peer-focus:text-[11px] before:content[' '] before:block before:w-2.5 before:h-1.5 before:mt-[6.5px] before:mr-1 before:rounded-tl-md before:pointer-events-none before:transition-all after:content[' '] after:block after:flex-grow after:w-2.5 after:h-1.5 after:mt-[6.5px] after:ml-1 after:pointer-events-none after:transition-all peer-placeholder-shown:leading-[3.75] text-gray-500 peer-focus:text-gray-900">Return</label>
        </label>
    </div>
</template>
<script>
import moment from 'moment';
import Litepicker from "litepicker";

export default {
    name: "RangeDatePicker",
    emits: ['update:modelValue', 'update:rangeDatePickerDates'],
    components: {
        Litepicker
    },
    data() {
        return {
            isXlScreen: false,
            bodyScroll: false,
        }
    },
    props: {
        obdDate: null,
        obdErrDate:null,
        ibdDate: null,
        ibdErrDate: null,
        modelValue: String,
        display: null,
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
        },
        initialStartInput: String,
        initialEndInput: String
    },
    watch: {
        modelValue(modelValue) {
            return this.setDateFormat(modelValue, 0);
        },
        obdDate(obdDate) {
            return this.setDateFormat(obdDate, 0);
        },
        ibdDate(ibdDate) {
            return this.setDateFormat(ibdDate, 0);
        }
    },
    mounted() {
        this.isXlScreen = window.innerWidth <= 640;
        window.addEventListener('resize', this.handleResize);
        new Litepicker({
            element: this.$refs.initialStartInput,
            elementEnd: this.$refs.initialEndInput,
            format: 'DD-MM-YYYY',
            singleMode: false,
            minDate: new Date(moment().subtract(1, 'days').toDate()),
            numberOfMonths: (this.isXlScreen ? 18 : 2),
            numberOfColumns: (this.isXlScreen ? 1 : 2),
            autoRefresh: true,
            autoApply: true,
            resetButton: true,
            allowRepick: true,
            position: 'right',
            buttonText: {apply: 'Done'},
            setup: (picker) => {
                picker.on('render', (ui) => {
                }),
                picker.on('selected', (start, end) => {
                        this.$emit('update:rangeDatePickerDates', this.setInoutboundDate(start.dateInstance, end.dateInstance, this.initialIndex));
                    }),
                picker.on('show', (start, end) => {
                        if(this.isXlScreen){
                            document.body.style.overflow = "hidden";
                            document.body.style.position = "fixed";
                            picker.gotoDate(new Date(moment().subtract(1, 'days').toDate()));
                        }
                    }),
                picker.on('hide', (start, end) => {
                        document.body.style.overflow = "";
                        document.body.style.position = "";
                    }),
                picker.on('button:apply', (start, end) => {
                        this.$emit('update:rangeDatePickerDates', this.setInoutboundDate(start.dateInstance, end.dateInstance, this.initialIndex));
                    });
                picker.on('render', () => {
                    const cancelBtn = document.querySelector('.litepicker .button-cancel');
                    if (cancelBtn) {
                        cancelBtn.remove();
                    }
                    const monthHeaders = document.querySelectorAll('.litepicker .month-item-header');
                    monthHeaders.forEach((header) => {
                        if (!header.querySelector('.close-icon')) {
                            const closeBtn = document.createElement('span');
                            closeBtn.classList.add('close-icon');
                            closeBtn.innerHTML = '&times;';
                            closeBtn.style.cursor = 'pointer';
                            closeBtn.style.float = 'right';
                            closeBtn.title = 'Close';
                            closeBtn.onclick = () => {
                                picker.hide();
                            };
                            header.appendChild(closeBtn);
                        }
                    });
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
        setInoutboundDate(start, end, initialIndex) {
            return JSON.parse(JSON.stringify({
                'trip': 'range',
                'start': this.setDateFormat(start, 0),
                'end': this.setDateFormat(end, 0),
                'index': initialIndex
            }))
        },
        setDateFormat(initialDate, days) {
            return moment((initialDate !== null ? initialDate : new Date()), "DD-MM-YYYY").add(days, 'day').format("DD-MM-YYYY");
        },
    },
};
</script>
<style>
.litepicker .close-icon {
    color: red;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    float: right;
    margin-left: 8px;
    margin-right: 4px;
    transition: color 0.2s ease;
}

.litepicker .close-icon:hover {
    color: darkred;
}
</style>
