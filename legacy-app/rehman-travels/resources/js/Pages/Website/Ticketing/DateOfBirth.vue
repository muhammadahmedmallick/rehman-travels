<script setup>
import moment from "moment";
import Litepicker from "litepicker";
</script>
<template>
  <div class="col-sm-12 m-0 p-0 w-100">
    <div class="flex justify-center items-center">
      <div class="w-full" style="display: grid;">
        <div class="form-group">
          <div class="cal-hight">
            <input
              :id="initialIndex"
              type="text"
              ref="initialInput"
              @input="$emit('update:modelValue', $event.target.value)"
              :value="modelValue"
              :class="'block px-2.5 pb-2.5 pt-4 w-full border border-solid border-gray-300 hover:border hover:border-solid hover:border-gray-400 text-base font-medium focus:border focus:border-solid outline-none text-gray-900 bg-transparent rounded-lg  appearance-none focus:ring-0 focus:border-blue-600 peer ' + initialClass"
              :placeholder="placeholder"
              autocomplete="off"
              readonly="readonly"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  components: {
    Litepicker,
  },
  emits: ["update:dbIssueExpiryDate"],
  props: {
    modelValue: {
      type: String,
    },
    initialClass: {
      type: String,
    },
    placeholder: {
      type: String,
    },
    initialInput: {
      type: String,
    },
    initialType: {
      type: String,
    },
    initialDate: {
      type: Object,
    },
    initialIndex: {
      type: Number,
    },
    outboundDate: {
      type: String,
    },
  },
  data(){
      return{
          isXlScreen: false,
          bodyScroll: false,
      }
  },
  watch: {
    modelValue(modelValue) {
      return modelValue;
    },
  },
  mounted() {
    this.isXlScreen = window.innerWidth <= 640;
    this.$nextTick(() => {
      let endAgeLimit = this.setEndAgeLimit();
      let startAgeLimit = this.setStartAgeLimit();
      new Litepicker({
        element: this.$refs.initialInput,
        format: "DD-MM-YYYY",
        maxDate: this.setMaxDate(endAgeLimit),
        minDate: this.initialType == "issueDate" || this.initialType == "expiryDate" ? "" : startAgeLimit,
        singleMode: true,
        numberOfMonths: 1,
        numberOfColumns: 1,
        splitView: true,
        switchingMonths: 1,
        autoRefresh: false,
        autoApply: false,
        resetButton: false,
        allowRepick:false,
        buttonText: {apply: 'Done'},
        dropdowns: {
          minYear:this.setMinYear(startAgeLimit),
          maxYear:this.setMaxYear(endAgeLimit),
          months: true,
          years: true,
        },
        setup: (picker) => {
            picker.on('show', () => {
              if(this.isXlScreen){
                  document.body.style.overflow = "hidden";
                  document.body.style.position = "fixed";
              }
            }),
            picker.on('hide', () => {
                  document.body.style.overflow = "";
                  document.body.style.position = "";
            }),
            picker.on("selected", (start) => {
                if(start !== null){this.$emit("update:dbIssueExpiryDate",this.setDbIssueExpiryDateDetail(start.dateInstance));}
              }),picker.on("button:apply", (start) => {
                  if(start !== null){this.$emit("update:dbIssueExpiryDate",this.setDbIssueExpiryDateDetail(start.dateInstance));}
            });
        },
      });
    });
  },
  methods: {
    setEndAgeLimit() { if (this.outboundDate !== undefined && this.outboundDate !== "") return this.setInitialDate(this.outboundDate, this.subAgeLimit())},
    setStartAgeLimit() { if (this.outboundDate !== undefined && this.outboundDate !== "") return this.setInitialDate(this.outboundDate, this.addAgeLimit())},
    subAgeLimit() {return this.initialType == "Adult" ? 11 : this.initialType == "Child" ? 2 : 0},
    addAgeLimit() {return this.initialType == "Adult" ? 60 : this.initialType == "Child" ? 11 : 2},
    setInitialDate(initialDate, year) {
      if (initialDate !== undefined && initialDate !== "")return moment(initialDate, "DD-MM-YYYY").subtract(year, "years").format("YYYY-MM-DD");
      else new Date();
    },
    setMaxDate(endAgeLimit){
      if(this.initialType == "expiryDate"){
        return "";
      }else if(this.initialType == "issueDate"){
        return new Date();
      }else{
        return endAgeLimit
      }
    },
    setMinYear(startAgeLimit){
      if(this.initialType == "expiryDate"){
      return moment(new Date()).year();
      }else if(this.initialType == "issueDate"){
        return moment(new Date()).subtract(5,"years").year();
      }else{
        return moment(startAgeLimit).year()
      }
    },
    setMaxYear(endAgeLimit){
      if(this.initialType == "expiryDate"){
      return moment(new Date()).add(10,"years").year();
      }else if(this.initialType == "issueDate"){
        return moment(new Date()).year();
      }else{
        return moment(endAgeLimit).year()
      }
    },
    setDbIssueExpiryDateDetail(start) {return {start:this.setDateFormat(start),initialType:this.initialType,initialIndex:this.initialIndex}},
    setDateFormat(initialDate) { return JSON.parse(JSON.stringify(moment(initialDate).format("DD-MM-YYYY")));},
  },
};
</script>
