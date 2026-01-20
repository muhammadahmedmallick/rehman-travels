export default {
    doRequest: function(amount, currencyRate) {
        if (currencyRate == 1) { return (eval(amount) / currencyRate)} else {return Math.round(eval(amount) / currencyRate) } //.toFixed(2)
    },
};
