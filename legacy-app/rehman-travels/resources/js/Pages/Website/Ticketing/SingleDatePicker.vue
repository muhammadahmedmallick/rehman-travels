<template>
    <label className="flex relative text-center align-middle">
        <img src="/calendar/calendar.svg" alt="calender" className="mr-1"/>
        <input type="text"
               v-on:keypress="isInteger"
               ref="initialInput"
               :value="(modelValue !== '' ? modelValue : '' )"
               v-on:input="$emit('update:modelValue', $event.target.value)"
               :id="initialStartInput"
               required="required"
               autocomplete="off"
               readonly="readonly"
               placeholder=""
               class="peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-0"
        />
        <label
            className="flex w-full h-full select-none pointer-events-none absolute left-2 font-medium !overflow-visible truncate peer-placeholder-shown:text-blue-gray-500 leading-tight peer-focus:leading-tight peer-disabled:text-transparent peer-disabled:peer-placeholder-shown:text-gray-500 transition-all -top-1.5 peer-placeholder-shown:text-sm text-[11px] peer-focus:text-[11px] before:content[' '] before:block before:w-2.5 before:h-1.5 before:mt-[6.5px] before:mr-1 before:rounded-tl-md before:pointer-events-none before:transition-all after:content[' '] after:block after:flex-grow after:w-2.5 after:h-1.5 after:mt-[6.5px] after:ml-1 after:pointer-events-none after:transition-all peer-placeholder-shown:leading-[3.75] text-gray-500 peer-focus:text-gray-900">
            Departure
        </label>
    </label>
</template>
<script>
import moment from 'moment';
import Litepicker from "litepicker";

export default {
    name: "SingleDatePicker",
    emits: ['update:modelValue', 'update:singleDatePickerDate'],
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
        initialStartInput: String
    },
    watch: {
        modelValue(modelValue) {
            return this.setDateFormat(modelValue, 0);
        }
    },
    mounted() {
        this.isXlScreen = window.innerWidth <= 640;
        window.addEventListener('resize', this.handleResize);
        new Litepicker({
            element: document.getElementById(this.initialInput),
            format: 'DD-MM-YYYY',
            singleMode: true,
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
                picker.on('selected', (start, end) => {
                    this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
                }),
                picker.on('show', (start, end) => {
                        if (this.isXlScreen) {
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
                        this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
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
        updateAutoOutinboundDate(initialDate) {
            let initialIndexs = (Number(this.initialLastIndex) - Number(this.initialIndex));
            let addDays = 0;
            for (let index = 0; index < initialIndexs; index++) {
                let initialIndex = Number(this.initialIndex) + Number(index);
                let outinboundDate = this.setDateFormat(initialDate, (initialIndex === 0 ? 0 : Number(addDays)));
                this.$emit('update:singleDatePickerDate', this.setInoutboundDate(outinboundDate, outinboundDate, initialIndex));
                addDays += 7;
            }
        },
        setInoutboundDate(start, end, initialIndex) {
            return JSON.parse(JSON.stringify({
                'trip': 'single',
                'start': this.setDateFormat(start, 0),
                'end': this.setDateFormat(end, 7),
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
