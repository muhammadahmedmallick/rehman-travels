<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Libraries\rest_api\OrderFareRuleProvider;

class CheapestFareFlightFareRuleController extends Controller {


    public function cheapestFareFlightFareRuleRequest(Request $request) {
        return OrderFareRuleProvider::cheapestFareFlightFareRuleReponse($request->route()->getPrefix(),$request);
    }

}
