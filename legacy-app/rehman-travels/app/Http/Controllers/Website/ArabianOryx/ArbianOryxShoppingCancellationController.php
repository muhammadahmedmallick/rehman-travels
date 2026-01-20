<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\Hotels\HotelShoppingCancellationServices;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ArbianOryxShoppingCancellationController extends Controller
{
    protected $hotelShoppingCancellationServices;
    public function __construct(HotelShoppingCancellationServices $hotelShoppingCancellationServices){
        $this->hotelShoppingCancellationServices = $hotelShoppingCancellationServices;
    }
    public function index_(Request $req){
        $hotelCancellationResp = HotelLibrary::hotelShoppingCancellation($req);
        \Log::info($hotelCancellationResp);
        $hotelCancellationDetails = [
            'hotel_booking_id' => $req['bck'],
            'hotel_cancellation_ex_rate' => '1.0000',
            'hotel_cancellation_status' => $hotelCancellationResp['status'],
            'hotel_cancellation_currency' => "USD",
            'created_by' => Auth::user()->id
        ];
        $cancelShopping = $this->hotelShoppingCancellationServices->store($hotelCancellationDetails);
        if($cancelShopping){
            return array(
                'error' => false,
                'status' => 4,
                'message' => 'Hotel Rooms are cancelled successfully'
            );
        }else{
            return array(
                'error' => true,
                'status' => '',
                'message' => 'Error!Hotel Rooms are not cancelled successfully'
            );
        }
    }
}
