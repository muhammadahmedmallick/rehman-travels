<?php

namespace App\Http\Controllers\Backend\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Services\Hotels\HotelBookingServices;
use App\Services\Hotels\HotelShoppingCancellationServices;
use App\Services\Hotels\HotelShoppingConfirmationServices;
use App\Services\Hotels\HotelShoppingInfoServices;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ManageLeadController extends Controller
{
    protected $hotelBookingServices;
    protected $hotelShoppingInfoServices;
    protected $hotelConfirmationsServices;
    protected $cancelShoppingServices;
    public function __construct(HotelBookingServices $hotelBookingServices, HotelShoppingInfoServices $hotelShoppingInfoServices, HotelShoppingConfirmationServices $hotelConfirmationsServices, HotelShoppingCancellationServices $cancelShoppingServices)
    {
        $this->hotelBookingServices = $hotelBookingServices;
        $this->hotelShoppingInfoServices = $hotelShoppingInfoServices;
        $this->hotelConfirmationsServices = $hotelConfirmationsServices;
        $this->cancelShoppingServices = $cancelShoppingServices;
    }
    public function index(Request $request){
        $from = $request['from'];
        $to = $request['to'];
        $where = array();
        if(!empty($from) && !empty($to)){
            $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to]];
        }else{
            $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' , date('Y-m-d')]];
        }
        $hotelsShoppingInfo = $this->hotelShoppingInfoServices->whereRelation($where, ['hotelbookings', 'hotelDetails']);
        if($hotelsShoppingInfo){
            $confirmationDetails = new Collection();
            foreach($hotelsShoppingInfo as $hotelShoppingInfoIndex => $hotelShoppingInfo){
                $hotelbookingsDetails = $hotelShoppingInfo['hotelbookings'][0];
                $confirmationDetails->push((object)[
                    'name' => $hotelShoppingInfo['hotelDetails']['name'],
                    'city' => $hotelShoppingInfo['hotelDetails']['city'],
                    'vendor' => $hotelShoppingInfo['hotelDetails']['vendor'],
                    'country_code' => $hotelShoppingInfo['country_code'],
                    'group_code' => $hotelShoppingInfo['group_code'],
                    'check_in' => $hotelbookingsDetails['check_in'],
                    'check_out' => $hotelbookingsDetails['check_out'],
                    't_nights' => $hotelbookingsDetails['t_nights'],
                    't_rooms' => $hotelbookingsDetails['t_rooms'],
                    't_adults' => $hotelbookingsDetails['t_adults'],
                    't_childs' => $hotelbookingsDetails['t_childs'],
                    'created_at' => date('d-m-Y H:i:s', strtotime($hotelShoppingInfo['created_at'])),
                ]);
            }
            return Inertia::render('Backend/ArabianOryx/HotelLeads', ['confirmationDetails' => $confirmationDetails]);
        }
    }
}
