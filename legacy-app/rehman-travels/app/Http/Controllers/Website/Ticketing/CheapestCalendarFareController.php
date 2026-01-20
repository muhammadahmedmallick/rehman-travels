<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use App\Libraries\rest_api\CheapestCalendarFareProvider;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CheapestCalendarFareController extends Controller {

    public function __construct(){

    }

    public function calendarFareRequest(Request $request) {
//        return CheapestCalendarFareProvider::calendarFareReponse($request);
        try {
            $filePath = 'calendar-fare/' . $request['fileName'];
            if (Storage::exists($filePath)) {
                return Storage::get($filePath) ?? [];
            } else {
                return CheapestCalendarFareProvider::calendarFareReponse($request);
            }
        } catch (\Exception $e) {
            return [];
        }
    }
}
