<?php

namespace App\Libraries\rest_api;

class OrderIssueProvider {

    public function __construct(){
        $this->middleware('auth:agent,user');
    }

    public static function cheapestFareOrderChangeReponse($request) {
        return ServiceProvider::doRequest("POST","orderChange", self::__orderChangeRequest($request));
    }

    public static function __orderChangeRequest($request) {
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
