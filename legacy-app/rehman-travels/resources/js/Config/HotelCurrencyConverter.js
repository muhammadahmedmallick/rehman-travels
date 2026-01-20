export default {
    doRequest: function(amount, currencyRate, uaeCurrencyRate) {
        if (currencyRate == uaeCurrencyRate) { return (eval(amount) / currencyRate)} else {return (eval(amount * uaeCurrencyRate) / currencyRate).toFixed(2) }
    },
};