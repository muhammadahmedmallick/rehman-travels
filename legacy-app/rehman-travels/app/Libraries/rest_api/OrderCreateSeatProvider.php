<?php

namespace App\Libraries\rest_api;

use AiremirateOrderCreateSeatProvider;
use AiromanOrderCreateSeatProvider;
use AirsialOrderCreateSeatProvider;
use AirpiaOrderCreateSeatProvider;
use AirblueOrderCreateSeatProvider;
use SabreOrderCreateSeatProvider;
use AirarabiaOrderCreateSeatProvider;
use TravelportOrderCreateSeatProvider;
use JazeeraairwaysOrderCreateSeatProvider;

class OrderCreateSeatProvider {

    public static function orderCreateSeat($request) {
        switch ($request->airType) :
            case "Emirate":
                return AiremirateOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Oman":
                return AiromanOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Airsial":
                return AirsialOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Pia":
                return AirpiaOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Airblue":
                return AirblueOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Sabre":
                return SabreOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Airarabia":
                return AirarabiaOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Travelport":
                return TravelportOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            case "Jazeeraairways":
                return JazeeraairwaysOrderCreateSeatProvider::orderCreateSeatResponse($request);
                break;
            default:
                echo "Your favorite color is neither red, blue, nor green!";
        endswitch;
    }

}
