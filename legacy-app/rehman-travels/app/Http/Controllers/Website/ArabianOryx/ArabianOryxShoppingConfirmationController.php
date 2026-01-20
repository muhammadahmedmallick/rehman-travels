<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Services\Hotels\HotelBookingServices;
use Illuminate\Support\Collection;
use Inertia\Inertia;

class ArabianOryxShoppingConfirmationController extends Controller
{
    protected $hotelBookingServices;
    public function __construct(HotelBookingServices $hotelBookingServices)
    {
        $this->hotelBookingServices = $hotelBookingServices;
    }

    public function index()
    {
        $input = request()->input();
        if(!empty($input['bck'])){
            $bookingDetails = $this->hotelBookingServices->whereRelation(['id' => $input['bck']], ['hotelBookingRooms', 'ShoppingInfo', 'hotelRoomDetails']);
            if($bookingDetails){
                $confirmationDetails = new Collection();
                foreach($bookingDetails as $bookingDetail){
                    $hotelBooking =[];
                    $isLead = "";
                    $bookingRoomKeys = [];
                    foreach($bookingDetail->hotelBookingRooms as $hotelBookingRoom){
                        $hotelInfo = $bookingDetail['ShoppingInfo']->hotelDetails;
                        $bookingRoomKeys[] = $bookingDetail->hotelBookingRooms[0]['room_key'];
                        foreach($hotelBookingRoom->roomsGuest as $roomsGuest){
                            $guestName = $roomsGuest['title']." ".$roomsGuest['firstName']." ".$roomsGuest['lastName'];
                            $hotelBooking[] = [
                                'id' => $roomsGuest['id'],
                                'guestName' => $guestName,
                                'isLeadPax' => $roomsGuest['isLeadPax'],
                            ];
                            if($isLead === "" && $roomsGuest['isLeadPax'] == 1){
                                $isLead =  $guestName;
                            }
                        }
                    }
                    $confirmationDetails->push((object)[
                        'shoppingDetails' => [
                            "check_in" => $bookingDetail['check_in'],
                            "check_out" => $bookingDetail['check_out'],
                            "t_nights" => $bookingDetail['t_nights'],
                            "t_rooms" => $bookingDetail['t_rooms'],
                            "t_adults" => $bookingDetail['t_adults'],
                            "t_childs" => $bookingDetail['t_childs'],
                        ],
                        'roomDetails' => [
                            'room_name' => $bookingDetail['hotelRoomDetails']->room_name,
                            'meal' => $bookingDetail['hotelRoomDetails']->meal,
                            'rate_type' => $bookingDetail['hotelRoomDetails']->rate_type,
                            'status' => $bookingDetail['hotelRoomDetails']->status,
                        ],
                        'roomGuests' => $hotelBooking,
                        'isLead' => $isLead,
                        'gross' => (count($bookingDetail->hotelBookingRooms) ? $bookingDetail->hotelBookingRooms[0]['eqtotal_base_fare'] : 0 ),
                        'net' => (count($bookingDetail->hotelBookingRooms) ? $bookingDetail->hotelBookingRooms[0]['eqtotal_prices'] : 0 ),
                        'tax' => (count($bookingDetail->hotelBookingRooms) ? $bookingDetail->hotelBookingRooms[0]['eqtotal_taxes'] : 0 ),
                        'hotelDetails' => [
                            'name' => ( !empty($hotelInfo) ? $hotelInfo['name'] : ''),
                            'address' => ( !empty($hotelInfo) ? $hotelInfo['address'] : '')
                        ]
                    ]);
                }
                return Inertia::render('Website/Hotels/ArabianOryxShoppingConfirmation', ['confirmationDetails' => $confirmationDetails]);
            }else{
                return redirect('/')->with(['errorType' => true, 'message' => 'Failed! unable to get the Booking details']);
            }
        }
    }
}
