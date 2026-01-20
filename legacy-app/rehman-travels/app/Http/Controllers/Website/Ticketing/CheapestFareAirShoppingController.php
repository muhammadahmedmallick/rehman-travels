<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Libraries\rest_api\AirTicketingMethodProvider;
use App\Libraries\rest_api\AirShoppingProvider;

class CheapestFareAirShoppingController extends Controller {


    public function cheapestFareAirshoppingRequest(Request $request) {
        $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInput(AirTicketingMethodProvider::params($request->input(),'p'));
        if(!empty($allowOnlyValidInputProvider)):
           return $allowOnlyValidInputProvider;
        else:
            $prefix = $request->route()->getPrefix();
            return airShoppingProvider::cheapestFareAirshoppingReponse($request,$prefix);
        endif;
    }
}
