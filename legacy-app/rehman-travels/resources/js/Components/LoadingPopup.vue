<template>
    <div v-if="showLoader" class="loader-overlay">
        <div class="loader-text">
            {{ currentMessage }}
        </div>
    </div>
</template>

<script>
export default {
    name: 'LoadingPopup',
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
                            this.$emit('loader-complete', false);
                        }, 1200);
                    }
                } else {
                    this.currentMessage = this.messages[this.messageIndex];
                }
            }, 1600);
        },
        stopLoader() {
            clearInterval(this.intervalId);
            this.showLoader = false;
            this.$emit('loader-complete', true);
        },
    },
};
</script>

<style scoped>
.loader-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    /*background-color: rgba(0, 0, 0, 0.6);*/
    z-index: 9999;
}
.loader-text {
    width: 100vw;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 20px;
    font-weight: 600;
    text-align: center;
    padding: 20px;
    animation: fadeIn 0.6s ease-in-out;
    background-color: rgba(0, 0, 0, 0.6);
}
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(8px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
@media (max-width: 600px) {
    .loader-text {
        font-size: 16px;
        padding: 16px;
    }
}
</style>
