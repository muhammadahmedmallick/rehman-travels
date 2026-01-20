<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use Illuminate\Http\Request;

class HotelPriceBreakupController extends Controller
{
    public function arabianOryxPriceBreakup(Request $req){
        return HotelLibrary::hotelPriceBreakup($req);
    }
}
