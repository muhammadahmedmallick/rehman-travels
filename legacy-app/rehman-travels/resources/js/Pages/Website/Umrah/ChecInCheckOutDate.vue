<template>
    <label class="flex">
        <img src="/calendar/calendar.svg" alt="calender" class="mr-1"/>
        <input type="text"
               v-on:keypress="isInteger"
               ref="initialInput"
               :value="`${(typeof formattedValue == 'string') ? formattedValue : (typeof formattedValue == 'object' && this.type == 'checkIn' ? formattedValue.checkIn : formattedValue.checkOut )}`"
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
    data() {
        return {
            isSmScreen: false,
            picker: null,
            formattedValue: '',
        }
    },
    props: {
        modelValue: [String, Date],
        flightType: String,
        type: String,
        tillDateHidden: [String, Date],
        initialIndex: Number,
        initialLastIndex: Number,
        initialInput: String,
        hotel: Object
    },
    computed: {
        minDate() {
            return (this.hotel && this.initialIndex == 0 ? new Date() : this.parseModelValue(this.hotel).checkIn);
        }
    },
    watch: {
        modelValue: {
            immediate: true,
            handler(newVal) {
                this.formatDisplayValue(newVal);
            },
        }
    },
    mounted() {
        this.isSmScreen = window.innerWidth <= 640;
        window.addEventListener('resize', this.handleResize);
        
        this.$nextTick(() => {
            if (this.$refs.initialInput) {
                const dates = this.parseModelValue(this.hotel);
                this.formattedValue = this.formatDisplayValueFromHotel(this.hotel);
                this.picker = new Litepicker({
                    element: this.$refs.initialInput,
                    elementEnd: this.$refs.initialInput,
                    format: 'DD-MM-YYYY',
                    singleMode: this.flightType !== "round-trip",
                    minDate: (this.hotel && this.initialIndex == 0 ? new Date() : dates.checkIn),
                    startDate: dates.checkIn || new Date(),
                    endDate: this.flightType === "round-trip" && dates.checkOut ? dates.checkOut : null,
                    numberOfMonths: this.isSmScreen ? 18 : 2,
                    numberOfColumns: this.isSmScreen ? 1 : 2,
                    autoRefresh: true,
                    autoApply: false,
                    resetButton: false,
                    switchingMonths: 1,
                    position: 'right',
                    setup: (picker) => {
                        picker.on('show', () => {
                            if (this.isSmScreen) {
                                document.body.style.position = "fixed";
                                document.body.style.overflow = "hidden";
                            }
                            this.formattedValue = this.formatDisplayValueFromHotel(this.hotel);
                            const currentDates = this.parseModelValue(this.hotel);
                            picker.setDateRange(
                                currentDates.checkIn || new Date(),
                                currentDates.checkOut || null
                            );
                            let currentSelection = (currentDates.checkIn ? currentDates.checkIn : new Date(this.minDate))
                            picker.gotoDate(currentSelection);
                        });
                        
                        picker.on('hide', () => {
                            document.body.style.overflow = "";
                            document.body.style.position = "";
                            this.formatDisplayValue(this.hotel);
                        });
                        
                        picker.on('selected', (start, end) => {
                            if (start) {
                                const startDate = this.formatDate(start.dateInstance);
                                const endDate = end ? this.formatDate(end.dateInstance) : null;
                                
                                const newValue = (this.flightType === "round-trip" && endDate) 
                                    ? `${startDate} - ${endDate}` 
                                    : startDate;
                                
                                this.$emit('update:modelValue', newValue);
                                this.formatDisplayValue(newValue);
                                
                                if (this.flightType !== "round-trip") {
                                    this.updateAutoOutinboundDate(start.dateInstance, this.initialIndex);
                                }
                                
                                this.$emit('update:outinboundDateDetail', {
                                    initialDate: {
                                        start: startDate,
                                        end: endDate || ''
                                    },
                                    initialIndex: this.initialIndex
                                });
                            }
                        });
                        
                        picker.on('button:cancel', () => {
                            this.formatDisplayValue(this.hotel);
                        });
                    }
                });
            }
        });
    },
    beforeDestroy() {
        if (this.picker) {
            this.picker.destroy();
        }
        window.removeEventListener('resize', this.handleResize);
    },
    methods: {
        formatDisplayValueFromHotel(hotel) {
            if (!hotel) return '';
            
            let checkIn = null;
            let checkOut = null;
            if (hotel.checkIn && hotel.checkOut) {
                checkIn = moment(hotel.checkIn, 'DD-MM-YYYY').format('DD-MM-YYYY');
                checkOut = moment(hotel.checkOut, 'DD-MM-YYYY').format('DD-MM-YYYY');
            }
            return {
                checkIn,
                checkOut,
            };
        },
        formatDisplayValue(value) {
            if (!value) {
                this.formattedValue = '';
                return;
            }
            
            if (value instanceof Date) {
                const formatted = moment(value).format('DD-MM-YYYY');
                this.formattedValue = moment(value).isValid() ? formatted : '';
                return;
            }
            
            if (typeof value === 'string') {
                if (value.includes(' - ')) {
                    const [start, end] = value.split(' - ');
                    const startValid = moment(start, 'DD-MM-YYYY', true).isValid();
                    const endValid = moment(end, 'DD-MM-YYYY', true).isValid();
                    if(this.type == 'checkIn'){
                        this.formattedValue = startValid && endValid 
                            ? moment(start, 'DD-MM-YYYY').format('DD-MM-YYYY')
                            : '';
                    }else if(this.type == 'checkOut'){
                        this.formattedValue = startValid && endValid 
                            ? moment(end, 'DD-MM-YYYY').format('DD-MM-YYYY')
                            : '';
                    }
                    return;
                }
                
                this.formattedValue = moment(value, 'DD-MM-YYYY', true).isValid() 
                    ? moment(value, 'DD-MM-YYYY').format('DD-MM-YYYY')
                    : '';
                return;
            }

            if (typeof value === 'object') {
                const startValid = moment(value.checkIn, 'DD-MM-YYYY', true).isValid();
                const endValid = moment(value.checkOut, 'DD-MM-YYYY', true).isValid();
                if(this.type == 'checkIn'){
                    this.formattedValue = startValid && endValid 
                        ? moment(value.checkIn, 'DD-MM-YYYY').format('DD-MM-YYYY')
                        : '';
                }else if(this.type == 'checkOut'){
                    this.formattedValue = startValid && endValid 
                        ? moment(value.checkOut, 'DD-MM-YYYY').format('DD-MM-YYYY')
                        : '';
                }
                return;
            }
            
            this.formattedValue = '';
        },

        handleCancel() {
            this.formatDisplayValue(this.hotel);
            const dates = this.parseModelValue(this.hotel);
            this.$emit('update:outinboundDateDetail', {
                initialDate: {
                    start: dates.checkIn ? this.formatDate(dates.checkIn) : '',
                    end: dates.checkOut ? this.formatDate(dates.checkOut) : ''
                },
                initialIndex: this.initialIndex
            });
        },
        
        parseModelValue(hotel) {
            const parseDate = (dateStr) => {
                if (!dateStr) return null;
                const [day, month, year] = dateStr.split("-");
                return year + "-" + month + "-" + day;
            };

            let checkIn = null;
            let checkOut = null;

            if (typeof hotel?.checkIn === 'string' && hotel.checkIn.includes(" - ")) { 
                const [checkInStr, checkOutStr] = hotel.checkIn.split(" - ");
                checkIn = parseDate(checkInStr.trim());
                checkOut = parseDate(checkOutStr.trim());
            } else {
                checkIn = parseDate(hotel?.checkIn);
                checkOut = parseDate(hotel?.checkOut);
            }

            return {
                checkIn,
                checkOut,
            };
        },
        
        formatDate(date) {
            return moment(date).format('DD-MM-YYYY');
        },
        
        handleResize() {
            this.isSmScreen = window.innerWidth <= 640;
        },
        
        isInteger(e) {
            e.preventDefault();
        },
        
        updateAutoOutinboundDate(initialDate) {
            let initialIndexs = (Number(this.initialLastIndex) - Number(this.initialIndex));
            let addDays = 0;
            for (let index = 0; index < initialIndexs; index++) {
                let initialIndex = Number(this.initialIndex) + Number(index);
                let outinboundDate = this.formatDate(moment(initialDate).add(addDays, 'days'));
                this.$emit('update:outinboundDateDetail', {
                    initialDate: {
                        start: outinboundDate,
                        end: outinboundDate
                    },
                    initialIndex: initialIndex
                });
                addDays += 7;
            }
        }
    }
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