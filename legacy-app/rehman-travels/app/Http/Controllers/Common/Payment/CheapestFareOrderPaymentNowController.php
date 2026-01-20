<?php

namespace App\Http\Controllers\Common\Payment;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;


class CheapestFareOrderPaymentNowController extends Controller {

    public function index(Request $request) {
        try {
            return Inertia::render('Website/Ticketing/CheapestFareOrderPayNow',['payInput' => ["airType" => $request['at'],"itineraryRef" => $request['irf']]]);
        } catch (\Exception $e) {
            return $e;
        }
    }


}
