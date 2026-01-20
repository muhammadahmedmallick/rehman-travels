<?php

namespace App\Libraries\rest_api;


use SabreRepriceOrderProvider;

class OrderRepriceProvider {

    public static function orderReprice($request) {
        switch ($request->airType) :
//            case "Oman":
//                return AiromanOrderCancelProvider::orderCancelResponse($request);
//                break;
//            case "Emirate":
//                return AiremirateOrderCancelProvider::orderCancelResponse($request);
//                break;
//            case "Airsial":
//                // @ no option 
//                 return "";
////                return AirsialOrderCancelProvider::orderCancelResponse($request);
//                break;
//            case "Pia":
//                return AirpiaOrderCancelProvider::orderCancelResponse($request);
//                break;
            case "Sabre":
                return SabreRepriceOrderProvider::orderRepriceResponse($request);
                break;
            default:
                echo "Your favorite color is neither red, blue, nor green!";
        endswitch;
    }

}
