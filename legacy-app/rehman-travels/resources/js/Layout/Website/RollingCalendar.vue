<template>
    <div class="calendar-container">
        <div class="calendar-slider">
            <div v-for="(pair, index) in visibleDatePairs" :key="index" class="calendar-day" :class="{ selected: index === selectedIndex }" @click="onDateClick(index)">
                <div>{{ mode === 'range' ? formatDisplay(pair.start) + ' - ' + formatDisplay(pair.end) : formatDisplay(pair.start) }}</div>
                <div v-if="getFare(pair.start)" class="fare">{{currency.currencySymbol}}{{ getFare(pair.start) }}</div>
            </div>
        </div>
    </div>
</template>

<script>
import Service from "@/Config/Service.js";
import CurrencyConverter from "@/Config/CurrencyConverter.js";
import {mapState} from "vuex";
export default {
    name: "RollingCalendar",
    props: {
        obd: { type: String, required: true },
        ibd: { type: String, default: "" },
        mode: { type: String, default: "range" },
        payload: {type: Object, default: () => ({})},
    },
    data() {
        return {
            datePairs: [],
            selectedIndex: 0,
            dayDifference: 0,
            rangeOffset: 3,
            fareData: {},
        };
    },
    computed: {
        ...mapState(['currency']),
        visibleDatePairs() {
            return this.datePairs;
        },
    },
    watch: {
        obd: "generateCalendar",
        ibd: "generateCalendar",
    },
    mounted() {
        this.setRangeOffset();
        this.generateCalendar();
        this.calendarFare();
        window.addEventListener("resize", this.onResize);
    },
    beforeDestroy() {
        window.removeEventListener("resize", this.onResize);
    },
    methods: {
        async calendarFare() {
            try {
                const payload = this.payload;
                const obdCode = payload.departureCode ?? ''
                const ibdCode = payload.arrivalCode ?? ''
                const cabin = payload.cabin ?? ''
                const tripType = payload.tripType ?? ''
                Service.doRequest("/ticketing/calendar-fare-request", 'POST', {
                    ol: obdCode,dl: ibdCode,cabin:cabin,tripType: tripType,
                    fileName:`${obdCode}_${ibdCode}_${cabin}_${tripType.replace(/[-]/g, '_')}.json`
                }).then((res) => {
                    this.fareData = res
                });
            } catch (error) {
                return [];
            }
        },
        onResize() {
            const previousOffset = this.rangeOffset;
            this.setRangeOffset();
            if (previousOffset !== this.rangeOffset) {
                this.generateCalendar();
            }
        },
        setRangeOffset() {
            this.rangeOffset = window.innerWidth <= 480 ? 1 : 3;
        },
        parseDateString(dateStr) {
            if (!dateStr) return null;
            const parts = dateStr.split("-");
            if (parts.length !== 3) return null;
            const [day, month, year] = parts.map(Number);
            return new Date(year, month - 1, day);
        },
        formatDisplay(date) {
            if (!date) return "";
            return date.toLocaleDateString(undefined, {day: "2-digit",month: "short"});
        },
        formatDate(date) {
            const d = date.getDate().toString().padStart(2, "0");
            const m = (date.getMonth() + 1).toString().padStart(2, "0");
            const y = date.getFullYear();
            return `${d}-${m}-${y}`;
        },
        generateCalendar() {
            const obdDate = this.parseDateString(this.obd);
            const endDate = this.mode === "range" ? this.parseDateString(this.ibd) : null;
            if (!obdDate) return;
            this.dayDifference = endDate && endDate > obdDate ? Math.floor((endDate - obdDate) / (1000 * 60 * 60 * 24)) : 0;
            this.datePairs = [];
            for (let i = -this.rangeOffset; i <= this.rangeOffset; i++) {
                const s = new Date(obdDate.getTime());
                s.setDate(s.getDate() + i);
                const e = new Date(s);
                e.setDate(s.getDate() + this.dayDifference);
                this.datePairs.push({ start: s, end: e });
            }
            this.selectedIndex = this.rangeOffset;
        },
        onDateClick(index) {
            this.selectedIndex = index;
            const pair = this.datePairs[index];
            const startStr = this.formatDate(pair.start);
            let selectedStr = startStr;
            if (this.mode === "range" && this.dayDifference > 0) {
                const endStr = this.formatDate(pair.end);
                selectedStr = `${startStr} - ${endStr}`;
            }
            this.$emit("update:selectedDate", selectedStr);
        },
        getFare(date) {
            const key = this.formatDateToISO(date);
            return this.isConverter(Math.round(this.fareData[key] ? this.fareData[key].totalFare : 0));
        },
        formatDateToISO(date) {
            const y = date.getFullYear();
            const m = (date.getMonth() + 1).toString().padStart(2, '0');
            const d = date.getDate().toString().padStart(2, '0');
            return `${y}-${m}-${d}`;
        },
         isConverter(amount) {
            return CurrencyConverter.doRequest(amount, this.currency.currencyRate ?? 1)
        }
    },
};
</script>

<style scoped>
.calendar-container {
    display: flex;
    justify-content: center;
    padding: 10px;
    overflow-x: auto;
}
.calendar-slider {
    display: flex;
    gap: 8px;
    flex-wrap: nowrap;
}
.calendar-day {
    cursor: pointer;
    padding: 10px 12px;
    border-radius: 8px;
    background-color: #fffefe;
    min-width: 120px;
    text-align: center;
    white-space: nowrap;
    user-select: none;
    transition: background-color 0.3s;
    font-size: 14px;
    flex-shrink: 0;
    border: 4px solid #007afe54;
}
.calendar-day.selected {
    background-color: #007bff;
    color: white;
    font-weight: bold;
}
@media (max-width: 480px) {
    .calendar-day {
        min-width: 100px;
        font-size: 13px;
        padding: 8px 10px;
    }
}
@media (max-width: 360px) {
    .calendar-day {
        min-width: 90px;
        font-size: 12px;
        padding: 6px 8px;
    }
}
</style>
