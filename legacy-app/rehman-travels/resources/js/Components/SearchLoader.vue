<template>
    <div v-if="showLoader" className="loader-container">
        <p className="loader-text">{{ currentMessage }}</p>
    </div>
</template>

<script>
export default {
    props: {
        isRecordFound: {
            type: [Boolean, Number],
            required: true,
        },
    },
    data() {
        return {
            messages: [
                "Initializing flight search engine...",
                "Preparing your personalized travel experience...",
                "Analyzing your travel criteria and destination preferences...",
                "Searching for the best available flights based on real-time data...",
                "Retrieving detailed flight information including times, airlines, and seat availability...",
                "Sorting and displaying the most affordable fares at the top for your convenience."
            ],
            currentMessage: "",
            showLoader: true,
            messageIndex: 0,
            intervalId: null,
        };
    },
    mounted() {
        this.startLoaderSequence();
    },
    watch: {
        isRecordFound(newVal) {
            if (newVal) {
                this.stopLoader();
            }
        },
    },
    methods: {
        startLoaderSequence() {
            this.currentMessage = this.messages[this.messageIndex];
            this.intervalId = setInterval(() => {
                this.messageIndex++;
                if (this.messageIndex >= this.messages.length) {
                    clearInterval(this.intervalId);
                    this.intervalId = null;
                    if (!this.isRecordFound) {
                        setTimeout(() => {
                            this.showLoader = false;
                        }, 1200);
                    }
                } else {
                    this.currentMessage = this.messages[this.messageIndex];
                }
            }, 1200);
        },
        stopLoader() {
            clearInterval(this.intervalId);
            this.showLoader = false;
        },
    },
};
</script>

<style scoped>
.loader-container {
    text-align: center;
    font-weight: bold;
    font-size: 15px;
}
.loader-text {
    animation: fadeIn 0.5s ease-in-out;
}
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}
</style>
