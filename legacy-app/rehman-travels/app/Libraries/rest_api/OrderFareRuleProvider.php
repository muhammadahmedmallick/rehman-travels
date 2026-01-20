<?php

namespace App\Libraries\rest_api;
use App\Libraries\rest_api\ServiceProvider;

class OrderFareRuleProvider {

    public static function cheapestFareFlightFareRuleReponse($prefix,$request) {
        return ServiceProvider::doRequest("POST","orderFareRule", self::__fareRuleRequest($request));
    }

    public static function __fareRuleRequest($request) {
        return '{
           "fareRuleKeys": ' . json_encode($request->fareRuleKeys) . ',
           "jSessionId": "' . $request->jSessionId . '",
           "airType": "' . $request->airType . '",
           "vCarrier": "' . $request->vCarrier . '"
        }';
    }

}
