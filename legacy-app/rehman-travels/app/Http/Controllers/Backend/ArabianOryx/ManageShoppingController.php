<?php

namespace App\Http\Controllers\Backend\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\Hotels\HotelBookingServices;
use App\Services\Hotels\HotelShoppingCancellationServices;
use App\Services\Hotels\HotelShoppingConfirmationServices;
use App\Services\Hotels\HotelShoppingInfoServices;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ManageShoppingController extends Controller
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
        $to = (!empty($request['to']) ? $request['to'] : date('Y-m-d'));
        $option = $request['option'];
        $where = array();
        if(!empty($from) && !empty($to)){
            $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' ,$from],[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '<=' ,$to]];
        }else{
            $where = [[DB::raw("(DATE_FORMAT(created_at,'%Y-%m-%d'))"), '>=' , $to]];
        }
        $hotelsShoppingInfo = $this->hotelShoppingInfoServices->whereRelation($where, ['hotelbookings', 'hotelDetails', 'hotelRoomDetails']);
        if($hotelsShoppingInfo){
            $confirmationDetails = new Collection();
            foreach($hotelsShoppingInfo as $hotelShoppingInfoIndex => $hotelShoppingInfo){
                $hotelBookingGuests =[];
                $isLead = "";
                $bookingRoomKeys = [];
                $hotelbookingsDetails = $hotelShoppingInfo['hotelbookings'][0];
                $checkBooking = $this->hotelConfirmationsServices->fetch(['hotel_booking_id' => $hotelbookingsDetails['id']]);
                $checkCancelShopping = $this->cancelShoppingServices->fetch(['hotel_booking_id' => $hotelbookingsDetails['id']]);
                if($checkBooking){
                    $customerDetials = [];
                    foreach($hotelShoppingInfo['hotelbookings'] as $hotelBookingRoom){
                        foreach($hotelBookingRoom->hotelBookingRooms as $hotelBookingRoomsIndex => $hotelBookingRooms){
                            $bookingRoomKeys[] = $hotelBookingRooms['room_key'];
                            foreach($hotelBookingRooms->roomsGuest as $roomsGuestIndex => $roomsGuest){
                                if($hotelBookingRoomsIndex === 0){$customerDetials[] =  $roomsGuest->customers;}
                                $guestName = $roomsGuest['title']." ".$roomsGuest['firstName']." ".$roomsGuest['lastName'];
                                $hotelBookingGuests[$hotelBookingRoomsIndex][] = [
                                    'id' => $roomsGuest['id'],
                                    'guestName' => $guestName,
                                    'isLeadPax' => $roomsGuest['isLeadPax'],
                                    'age' => $roomsGuest['age'],
                                ];
                                if($isLead === "" && $roomsGuest['isLeadPax'] == 1){
                                    $isLead =  $guestName;
                                }
                            }
                        }
                    }
                    if (!empty($checkCancelShopping) && $checkCancelShopping['hotel_booking_id'] == $hotelbookingsDetails['id'] && $option == '4') {
                        $confirmationDetails->push($this->createConfirmationDetails($hotelbookingsDetails, $hotelShoppingInfo, $hotelBookingGuests, $isLead, $checkBooking, $checkCancelShopping, $customerDetials, $bookingRoomKeys));
                        continue;
                    } elseif (empty($checkCancelShopping) && $option == '2') {
                        $confirmationDetails->push($this->createConfirmationDetails($hotelbookingsDetails, $hotelShoppingInfo, $hotelBookingGuests, $isLead, $checkBooking, $checkCancelShopping, $customerDetials, $bookingRoomKeys));
                    } elseif ($option == '') {
                        $confirmationDetails->push($this->createConfirmationDetails($hotelbookingsDetails, $hotelShoppingInfo, $hotelBookingGuests, $isLead, $checkBooking, $checkCancelShopping, $customerDetials, $bookingRoomKeys));
                    }
                }
            }
            return Inertia::render('Backend/ArabianOryx/HotelBookings', ['hotelBookings' => $confirmationDetails]);
        }else{
            return redirect('/')->with(['errorType' => true, 'message' => 'Failed! unable to get the Booking details']);
        }
    }

    private function createConfirmationDetails($hotelbookingsDetails, $hotelShoppingInfo, $hotelBookingGuests, $isLead, $checkBooking, $checkCancelShopping, $customerDetails, $bookingRoomKeys) {
        return (object)[
            'shoppingDetails' => [
                "check_in" => $hotelbookingsDetails['check_in'],
                "check_out" => $hotelbookingsDetails['check_out'],
                "t_nights" => $hotelbookingsDetails['t_nights'],
                "t_rooms" => $hotelbookingsDetails['t_rooms'],
                "t_adults" => $hotelbookingsDetails['t_adults'],
                "t_childs" => $hotelbookingsDetails['t_childs'],
                "session_id" => $hotelbookingsDetails['hotel_session_id'],
            ],
            'created_at' => date('d-m-Y H:i:s', strtotime($hotelShoppingInfo['created_at'])),
            'roomGuests' => $hotelBookingGuests,
            'isLead' => $isLead,
            'bckConfirmId' => $checkBooking['confirmation_key'],
            'status' => $checkBooking['hotel_confirmation_status'],
            'cancelStatus' => (!empty($checkCancelShopping) ? $checkCancelShopping['hotel_cancellation_status'] : $checkBooking['hotel_confirmation_status']),
            'booking_id' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['hotel_booking_id'] : ''),
            'd_currency' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['d_currency'] : 'USD'),
            'd_currency_rate' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['d_currency_rate'] : '0.00'),
            's_currency' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['s_currency'] : 'USD'),
            's_currency_rate' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['s_currency_rate'] : '0.00'),
            'gross' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['total_base_fare'] : 0),
            'net' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['total_prices'] : 0),
            'tax' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['total_taxes'] : 0),
            'eqgross' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['eqtotal_base_fare'] : 0),
            'eqnet' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['eqtotal_prices'] : 0),
            'eqtax' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['eqtotal_taxes'] : 0),
            'markup' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['markup'] : ''),
            'markupType' => (count($hotelbookingsDetails->hotelBookingRooms) > 0 ? $hotelbookingsDetails->hotelBookingRooms[0]['markup_type'] : ''),
            'hotelDetails' => [
                'hotelSessionId' => $hotelbookingsDetails['hotel_session_id'],
                'name' => $hotelShoppingInfo['hotelDetails']['name'],
                'city' => $hotelShoppingInfo['hotelDetails']['city'],
                'hotelSessionId' => $hotelbookingsDetails['hotel_session_id'],
                'groupCode' => $hotelShoppingInfo['group_code'],
                'destinationCode' => $hotelShoppingInfo['destination_code'],
                'rateKey' => $bookingRoomKeys,
            ],
            'hotelRoomDetails' => [
                'room_name' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['room_name']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['room_name'] : '' ),
                'meal' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['meal']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['meal'] : '' ),
                'rate_type' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['rate_type']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['rate_type'] : '' ),
                'rate_key' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['rate_key']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['rate_key'] : '' ),
                'status' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['status']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['status'] : '' ),
                'reprice' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['reprice']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['reprice'] : '' ),
                'is_price_breakup_available' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['is_price_breakup_available']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['is_price_breakup_available'] : '' ),
                'is_cancelation_policy_availble' => (!empty($hotelShoppingInfo['hotelRoomDetails']) && isset($hotelShoppingInfo['hotelRoomDetails'][0]['is_cancelation_policy_availble']) ? $hotelShoppingInfo['hotelRoomDetails'][0]['is_cancelation_policy_availble'] : '' ),
            ],
            'customerInfo' => $customerDetails[0]
        ];
    }
    
    public function getHotelDetails(Request $req){
        $inputDetails = [
            'hotelSessionId' => $req['hotelSessionId'],
            'hotelCode' => $req['hotelCode'],
            'groupCode' => $req['groupCode'],
            'destinationCode' => $req['destinationCode'],
            'rateKey' => $req['rateKey'],
        ];
        $hotelDetail = HotelLibrary::hotelPriceAndAvailibility($inputDetails);
        return array(
            'hotelInfo' => ($hotelDetail != "" || $hotelDetail != null ? $hotelDetail['hotel']['hotelInfo'] : ''),
            'roomInfo' => ($hotelDetail != "" || $hotelDetail != null ? $hotelDetail['hotel']['rooms'] : '')
        );
    }
}
