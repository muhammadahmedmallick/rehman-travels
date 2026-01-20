<?php

namespace App\Libraries\rest_api;

class OrderRetrieveProvider {

    public static function cheapestFareOrderRetrieveReponse($request) {
        return ServiceProvider::doRequest("POST","orderRetrieve", self::__orderRetrieveRequest($request));
    }

    public static function __orderRetrieveRequest($request) {
        return '{
            "airType": "' . $request['airType'] . '",
            "pnr": "' . ($request['airType'] != "Travelport" ? $request['itineraryRef'] : $request['echoToken']) . '",
            "reference": "' . $request['reference'] . '",
            "echoToken": "' . $request['echoToken'] . '",
            "jSessionId":"'.$request['jSessionId'].'",
            "vCarrier":"' . $request['vCarrier'] . '",
            "currencyRate":"' . $request['currencyRate'] . '",
            "currencyCode":"' . $request['currencyCode'] . '",
            "receivableAccount":"REHMAN GROUP OF TRAVELS",
            "paymentAmount":""
        }';
    }

}
