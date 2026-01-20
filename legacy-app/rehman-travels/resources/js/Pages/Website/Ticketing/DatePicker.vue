<template>
    <div class="datepicker-wrapper" ref="wrapper">
        <div v-if="mode === 'single' || mode === 'multi'">
            <input type="text" v-model="formattedDate" @focus="openCalendarFor('single')"
                   :readonly="true"
                   required="required" autocomplete="off" placeholder="Departure"
                   class="peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-4"
            />
            <i class="fas fa-calendar-alt left-0 absolute top-1/2 transform -translate-y-1/2 text-red-400 pointer-events-none" @click="openCalendarFor('single')"></i>
        </div>
        <div v-else class="range-inputs">
            <div
                :class="`${(obdErrDate !== '' && rangeStartText === '') ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md  md:mr-0`">
                <i class="fas fa-calendar-alt text-red-400 text-lg cursor-pointer" @click="openCalendarFor('start')"></i>
                <input type="text" v-model="rangeStartText" @focus="openCalendarFor('start')"
                       required="required" autocomplete="off" :readonly="true" placeholder="Departure"
                       class="focus:bg-white focus:border-blue-500 peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-2"/>
            </div>
            <div
                :class="`${(ibdErrDate !== '' && rangeEndText === '') ? 'border-red-500 border-2' : 'border-gray-300'} w-1/2 my-2 md:my-0 md:mt-0 flex items-center h-14 border hover:border-gray-400 px-1 py-[0.32rem] bg-white  rounded-md md:mr-0`">
                <i class="fas fa-calendar-alt text-red-400 text-lg cursor-pointer" @click="openCalendarFor('end')"></i>
                <input type="text"
                       v-model="rangeEndText" @focus="openCalendarFor('end')"
                       required="required" autocomplete="off" :readonly="true" placeholder="Returning"
                       class="focus:bg-white focus:border-blue-500 peer w-full font-semibold sm:overflow-auto overflow-hidden lg:text-[14px] focus:outline-none border-none focus:ring-0 px-2"/>
            </div>
        </div>
        <div v-if="showCalendar" class="calendar-container">
            <div class="calendar-nav">
                <button @click="prevGroup" :disabled="isPrevDisabled">&lt;</button>
                <span>{{ visibleRangeText }}</span>
                <button @click="nextGroup">&gt;</button>
            </div>
            <div class="months" :class="{ 'vertical-mobile': isMobile }"
                 :style="!isMobile ? { gridTemplateColumns: `repeat(${monthsToShow}, 1fr)` } : {}">
                <div v-for="index in (isMobile ? 12 : monthsToShow)" :key="'month-' + index" class="calendar">
                    <div class="calendar-header">{{ getMonthYear(index - 1) }}</div>
                    <div class="calendar-days">
                        <div v-for="d in days" :key="'day-label-' + d">{{ d }}</div>
                    </div>
                    <div class="calendar-dates">
                        <div v-for="n in getOffset(index - 1)" :key="'blank-' + index + '-' + n" class="blank"></div>
                        <div v-for="d in getDaysInMonth(index - 1)" :key="'date-' + index + '-' + d" class="date-cell">
                            <div
                                :class="{
                                  selected: isSelectedDate(d, index - 1),
                                  'range-start': isRangeStart(d, index - 1),
                                  'range-end': isRangeEnd(d, index - 1),
                                  'in-range': isInRange(d, index - 1),
                                  // disabled: isPastDate(d, index - 1)
                                  disabled: isInvalidStartDate(d, index - 1)
                                }"
                                @click="!isInvalidStartDate(d, index - 1) && selectDate(d, index - 1)">
                                {{ d }}
                                <small v-if="hasFare(d, index - 1)" class="fare-text">
                                    {{ currency.currencySymbol }}{{ hasFare(d + 1, index - 1) }}
                                </small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="calendar-actions">
                <button v-if="showClearButton" @click="handleClear">Clear</button>
                <button v-if="showApplyButton && confirmOnApply" @click="handleApply">Apply</button>
                <button v-if="showDoneButton" @click="handleDone">Done</button>
                <button v-if="showCancelButton" class="cancel-btn" @click="handleCancel">×</button>
            </div>
        </div>
    </div>
</template>
<script setup>
import {ref, computed, watch, onMounted, onUnmounted, reactive} from "vue";
import moment from 'moment';
import Service from "@/Config/Service.js";
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import {useStore} from "vuex";

const props = defineProps({
    monthsToShow: {type: Number, default: 2},
    mode: {type: String, default: "single", validator: (val) => ["single", "range", "multi"].includes(val)},
    obdDate: {type: String, default: ''},
    obdErrDate: {type: String, default: ''},
    ibdDate: {type: String, default: ''},
    ibdErrDate: {type: String, default: ''},
    multiPrevDate: {type: String, default: ''},
    initialIndex: {type: Number, default: 1},
    obdCode: {type: String, default: ''},
    ibdCode: {type: String, default: ''},
    tripType: {type: String, default: 'round-trip'},
    cabin: {type: String, default: 'Y'},
    currencyRate: {type: Number, default: 1},
    calendarFares: {type: Object, default: () => ({})},
});
const fareData = ref({});
const isLoadingFares = ref(false);
const store = useStore()
const currency = computed(() => store.state.currency)
const emit = defineEmits(['update:modelValue', 'update:range', 'clear']);
const allowPast = ref(false);
const confirmOnApply = ref(false);
const showApplyButton = ref(false);
const showDoneButton = ref(false);
const showClearButton = ref(false);
const showCancelButton = ref(true);
const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
const days = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"];
const today = new Date();
const startDate = ref(new Date(today.getFullYear(), today.getMonth(), 1));
const showCalendar = ref(false);
const selectedDate = ref(null);
const rangeStart = ref(null);
const rangeEnd = ref(null);
const tempRangeStart = ref(null);
const isMobile = ref(false);

function checkIsMobile() {
    isMobile.value = window.innerWidth <= 768;
}

onMounted(() => {
    checkIsMobile();
    fetchFareData();
    window.addEventListener("resize", checkIsMobile);
    if (props.mode === "single" || props.mode === "multi" && props.obdDate) {
        const date = moment(props.obdDate, "DD-MM-YYYY", true);
        if (date.isValid()) {
            selectedDate.value = date.toDate();
        }
    } else if (props.mode === "range") {
        const start = moment(props.obdDate, "DD-MM-YYYY", true);
        const end = moment(props.ibdDate, "DD-MM-YYYY", true);
        if (start.isValid()) rangeStart.value = start.toDate();
        if (end.isValid()) rangeEnd.value = end.toDate();
    }
});
watch(() => props.obdDate, (newVal) => {
    if (props.mode === "single" || props.mode === "multi" && newVal) {
        const date = moment(newVal, "DD-MM-YYYY", true);
        if (date.isValid()) {
            selectedDate.value = date.toDate();
        }
    }
});
watch(() => props.ibdDate, (newVal) => {
    if (props.mode === "range" && newVal) {
        const date = moment(newVal, "DD-MM-YYYY", true);
        if (date.isValid()) {
            rangeEnd.value = date.toDate();
        }
    }
});
watch([rangeStart, rangeEnd], () => {
    if (props.mode === "range") {
        emit('update:range', {
            trip: props.mode,
            start: rangeStart.value ? setDateFormat(rangeStart.value) : '',
            end: rangeEnd.value ? setDateFormat(rangeEnd.value) : '',
            obdErrDate: '',
            ibdErrDate: '',
            index: props.initialIndex
        });
    }
});
watch(selectedDate, () => {
    if (props.mode === "single" || props.mode === "multi") {
        emit('update:modelValue', {
            trip: props.mode,
            start: selectedDate.value ? setDateFormat(selectedDate.value) : '',
            end: setDateFormat(selectedDate.value, 7),
            obdErrDate: '',
            ibdErrDate: '',
            index: props.initialIndex
        });
    }
});
watch([() => props.obdCode, () => props.ibdCode], () => {
    fetchFareData();
});
onUnmounted(() => {
    window.removeEventListener("resize", checkIsMobile);
});
// const formattedDate = computed(() => selectedDate.value ? selectedDate.value.toDateString() : formatToReadableDate(props.obdDate));
// const rangeStartText = computed(() => rangeStart.value ? rangeStart.value.toDateString() : formatToReadableDate(props.obdDate));
// const rangeEndText = computed(() => rangeEnd.value ? rangeEnd.value.toDateString() : formatToReadableDate(props.ibdDate));

const formattedDate = computed(() => selectedDate.value ? moment(selectedDate.value).format("DD MMM, YYYY") : formatToReadableDate(props.obdDate));
const rangeStartText = computed(() => rangeStart.value ? moment(rangeStart.value).format("DD MMM, YYYY") : formatToReadableDate(props.obdDate));
const rangeEndText = computed(() =>rangeEnd.value ? moment(rangeEnd.value).format("DD MMM, YYYY") : formatToReadableDate(props.ibdDate));


function openCalendarFor(type) {
    if (props.mode === "range") {
        if (!rangeStart.value && !rangeEnd.value && type === "start") {
            showCalendar.value = "range-selecting";
            tempRangeStart.value = null;
            return;
        }
        if (!rangeStart.value && type === "end") {
            showCalendar.value = "range-selecting";
            tempRangeStart.value = null;
            return;
        }
        if (rangeStart.value && rangeEnd.value) {
            showCalendar.value = type;
            tempRangeStart.value = null;
            return;
        }
        showCalendar.value = type;
    } else if (props.mode === "multi") {
        showCalendar.value = "multi";
    } else {
        showCalendar.value = "single";
    }
    fetchFareData();
}

async function fetchFareData() {
    if (!props.obdCode || !props.ibdCode) return;
    isLoadingFares.value = true;
    try {
        const response = await Service.doRequest("/ticketing/calendar-fare-request", 'POST', {
            ol: props.obdCode, dl: props.ibdCode, cabin: props.cabin, tripType: props.tripType,
            fileName: `${props.obdCode}_${props.ibdCode}_${props.cabin}_${props.tripType.replace(/[-]/g, '_')}.json`
        })
        fareData.value = response || {};
    } catch (err) {
        console.error("Fetch calendar fares failed:", err);
    } finally {
        isLoadingFares.value = false;
    }
}

function isInvalidStartDate(day, offsetIndex) {
    const date = getDateObject(day, offsetIndex);
    if (allowPast.value === false && date < new Date(today.getFullYear(), today.getMonth(), today.getDate())) {
        return true;
    }
    if (allowPast.value === false && props.mode === "multi" && props.multiPrevDate) {
        if (date < parseDateFromString(props.multiPrevDate)) {
            return true;
        }
    }
    if (showCalendar.value === "end" && rangeStart.value) {
        return date < rangeStart.value;
    }
    return false;
}

function parseDateFromString(dateStr) {
    const [day, month, year] = dateStr.split("-").map(Number);
    return new Date(year, month - 1, day + 1);
}

function getMonthYear(offsetIndex) {
    const date = new Date(startDate.value);
    date.setMonth(date.getMonth() + offsetIndex);
    return `${months[date.getMonth()]} ${date.getFullYear()}`;
}

function getDaysInMonth(offsetIndex) {
    const date = new Date(startDate.value);
    date.setMonth(date.getMonth() + offsetIndex + 1, 0);
    return date.getDate();
}

function getOffset(offsetIndex) {
    const date = new Date(startDate.value);
    date.setMonth(date.getMonth() + offsetIndex, 1);
    return date.getDay();
}

function getDateObject(day, offsetIndex) {
    const date = new Date(startDate.value);
    date.setMonth(date.getMonth() + offsetIndex, day);
    date.setHours(0, 0, 0, 0);
    return date;
}

function isPastDate(day, offsetIndex) {
    if (allowPast.value) return false;
    const d = getDateObject(day, offsetIndex);
    const t = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    return d < t;
}

function selectDate(day, offsetIndex) {
    const selected = getDateObject(day, offsetIndex);
    if (props.mode === "single" || props.mode === "multi") {
        selectedDate.value = selected;
        if (!confirmOnApply.value) {
            showCalendar.value = false;
        }
    } else if (showCalendar.value === "range-selecting") {
        if (!tempRangeStart.value) {
            tempRangeStart.value = selected;
        } else {
            if (selected < tempRangeStart.value) {
                rangeStart.value = selected;
                rangeEnd.value = tempRangeStart.value;
            } else {
                rangeStart.value = tempRangeStart.value;
                rangeEnd.value = selected;
            }
            tempRangeStart.value = null;
            if (!confirmOnApply.value) {
                showCalendar.value = false;
            }
        }
    } else if (showCalendar.value === "start") {
        rangeStart.value = selected;
        if (rangeEnd.value && rangeEnd.value < selected) {
            rangeEnd.value = null;
            tempRangeStart.value = selected;
            showCalendar.value = "range-selecting";
            return;
        }
        if (!confirmOnApply.value) {
            showCalendar.value = false;
        }
    } else if (showCalendar.value === "end") {
        rangeEnd.value = selected;
        if (rangeStart.value && rangeStart.value > rangeEnd.value) {
            rangeStart.value = null;
        }
        if (!confirmOnApply.value) {
            showCalendar.value = false;
        }
    }
}

function setDateFormat(date, daysToAdd = 0) {
    const baseDate = date ? moment(date, 'DD-MM-YYYY', true).isValid() ? moment(date, 'DD-MM-YYYY') : moment(date) : moment();
    return baseDate.add(daysToAdd, 'days').format('DD-MM-YYYY');
}

function formatToReadableDate(dateStr) {
    const momentDate = moment(dateStr, 'DD-MM-YYYY', true);
    if (!momentDate.isValid()) {
        return '';
    }
    return momentDate.format('ddd MMM DD YYYY');
}

function isSelectedDate(day, offsetIndex) {
    const d = getDateObject(day, offsetIndex);
    return (
        (selectedDate.value && selectedDate.value.toDateString() === d.toDateString()) ||
        (rangeStart.value && rangeStart.value.toDateString() === d.toDateString()) ||
        (rangeEnd.value && rangeEnd.value.toDateString() === d.toDateString()) ||
        (tempRangeStart.value && tempRangeStart.value.toDateString() === d.toDateString())
    );
}

function isRangeStart(day, offsetIndex) {
    return (rangeStart.value && getDateObject(day, offsetIndex).toDateString() === rangeStart.value.toDateString());
}

function isRangeEnd(day, offsetIndex) {
    return (rangeEnd.value && getDateObject(day, offsetIndex).toDateString() === rangeEnd.value.toDateString());
}

function isInRange(day, offsetIndex) {
    if (!rangeStart.value || !rangeEnd.value) return false;
    const d = getDateObject(day, offsetIndex);
    return d > rangeStart.value && d < rangeEnd.value;
}

function prevGroup() {
    const newDate = new Date(startDate.value);
    newDate.setMonth(newDate.getMonth() - props.monthsToShow);
    const currMonthStart = new Date(today.getFullYear(), today.getMonth(), 1);
    if (newDate >= currMonthStart) {
        startDate.value = newDate;
    } else {
        startDate.value = currMonthStart;
    }
}

function nextGroup() {
    const newDate = new Date(startDate.value);
    newDate.setMonth(newDate.getMonth() + props.monthsToShow);
    startDate.value = newDate;
}

const isPrevDisabled = computed(() => {
    const currMonthStart = new Date(today.getFullYear(), today.getMonth(), 1);
    return startDate.value <= currMonthStart;
});
const visibleRangeText = computed(() => {
    if (isMobile.value) {
        return "12 months";
    } else if (props.monthsToShow === 1) {
        return getMonthYear(0);
    } else {
        const start = new Date(startDate.value);
        const end = new Date(startDate.value);
        end.setMonth(end.getMonth() + props.monthsToShow - 1);
        return `${months[start.getMonth()]} ${start.getFullYear()} — ${months[end.getMonth()]} ${end.getFullYear()}`;
    }
});

function handleClear() {
    selectedDate.value = null;
    rangeStart.value = null;
    rangeEnd.value = null;
    tempRangeStart.value = null;
    props.multiPrevDate = null;
    showCalendar.value = false;
    emit('clear');
}

function handleApply() {
    showCalendar.value = false;
}

function handleDone() {
    showCalendar.value = false;
}

function handleCancel() {
    showCalendar.value = false;
}

const wrapper = ref(null);

function onClickOutside(event) {
    if (wrapper.value && !wrapper.value.contains(event.target)) {
        showCalendar.value = false;
    }
}

function hasFare(day, offsetIndex) {
    const date = getDateObject(day, offsetIndex);
    const key = date.toISOString().split("T")[0];
    return isConverter(Math.round(fareData.value[key]?.totalFare || 0));
}

function isConverter(amount) {
    return CurrencyConverter.doRequest(amount, currency.value.currencyRate ?? 1)
}

onMounted(() => {
    document.addEventListener("click", onClickOutside);
});
onUnmounted(() => {
    document.removeEventListener("click", onClickOutside);
});
</script>
<style scoped>
.datepicker-wrapper {
    position: relative;
    width: 100%;
    max-width: 340px;
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    user-select: none;
    margin: 0 auto;
}

.range-inputs {
    display: flex;
    flex-direction: row;
    align-items: center;
    flex-wrap: nowrap;
    gap: 8px;
}

.range-inputs .dash {
    user-select: none;
    font-weight: 600;
    color: #555;
    font-size: 16px;
}

.calendar-container {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    border: 1px solid #ccc;
    border-radius: 6px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
    z-index: 1000;
    padding: 12px;
    max-width: 90vw;
    max-height: 90vh;
    overflow: auto;
}

.calendar-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.4);
    z-index: 999;
}

.calendar-nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
}

.calendar-nav button {
    background-color: #1976d2;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 4px 12px;
    cursor: pointer;
    font-weight: 600;
}

.calendar-nav button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.months {
    display: grid;
    gap: 10px;
}

.vertical-mobile {
    grid-template-columns: 1fr !important;
    max-height: 360px;
    overflow-y: auto;
}

.calendar {
    border: 1px solid #ddd;
    border-radius: 6px;
    padding: 8px;
}

.calendar-header {
    font-weight: bold;
    margin-bottom: 6px;
    text-align: center;
}

.calendar-days,
.calendar-dates {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 4px;
}

.calendar-days > div,
.calendar-dates > div > div {
    text-align: center;
    padding: 4px;
    font-size: 12px;
}

.calendar-dates > div > div {
    border-radius: 4px;
    cursor: pointer;
}

.calendar-dates > div > div.selected {
    background-color: #1976d2;
    color: white;
}

.calendar-dates > div > div.range-start,
.calendar-dates > div > div.range-end {
    background-color: #64b5f6;
    color: white;
}

.calendar-dates > div > div.in-range {
    background-color: #bbdefb;
}

.calendar-dates > div > div.disabled {
    pointer-events: none;
    color: #ccc;
}

.calendar-actions {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    gap: 8px;
    flex-wrap: wrap;
}

.calendar-actions button {
    padding: 6px 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;
    /*background-color: #f5f5f5;*/
    color: #333;
}

.cancel-btn {
    position: absolute;
    top: 8px;
    right: 55px;
    z-index: 10;
    background: transparent;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: red;
}

@media (max-width: 768px) {
    .calendar-container {
        width: 95vw;
        max-width: 95vw;
        max-height: 90vh;
    }

    .datepicker-wrapper {
        max-width: 100% !important;
    }

    .range-inputs {
        /*flex-direction: column;*/
        display: flex;
        flex-direction: row;
        align-items: center;
        flex-wrap: nowrap;
        gap: 8px;
        align-items: stretch;
        width: 100%;
    }

    input[type="text"] {
        width: 100%;
    }

    .calendar-actions {
        justify-content: center;
    }
}

@media (max-width: 480px) {
    .calendar-nav {
        flex-direction: column;
        gap: 8px;
    }

    .datepicker-wrapper {
        max-width: 100% !important;
    }

    .calendar-actions {
        flex-direction: column;
        gap: 8px;
        align-items: stretch;
    }

    .calendar-nav button {
        width: 100%;
    }
}
</style>
