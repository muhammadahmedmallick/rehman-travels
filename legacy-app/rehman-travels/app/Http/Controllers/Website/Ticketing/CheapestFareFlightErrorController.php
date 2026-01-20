<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Session;
class CheapestFareFlightErrorController extends Controller
{
    public function index(Request $request){
            return Inertia::render('Website/Ticketing/Error',['errors' => self::__error()]);
    }

    private static function __error(){
        return  '{"input":"true","error":"'.(!empty(Session::get('error')) ? Session::get('error') : 'Invalid error occure please try again').'"}';
    }

}
