<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;

class OrderCreateController extends Controller {

    public function cheapestFareFlightOrderCreate(Request $request) {
        return Inertia::render('Website/Ticketing/CheapestFareFlightOrderCreate');
    }

}
