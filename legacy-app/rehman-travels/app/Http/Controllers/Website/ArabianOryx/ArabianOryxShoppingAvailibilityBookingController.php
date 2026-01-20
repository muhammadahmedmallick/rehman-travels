<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\Customer\CustomerService;
use App\Services\Hotels\HotelBookingRoomsServices;
use App\Services\Hotels\HotelMarkupServices;
use App\Services\Hotels\HotelRoomDetailServices;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ArabianOryxShoppingAvailibilityBookingController extends Controller
{
    protected $hotelBookingRoomsServices;
    protected $customerService;
    protected $markupServices;
    protected $hotelRoomDetailServices;

    public function __construct(HotelMarkupServices $markupServices, HotelRoomDetailServices $hotelRoomDetailServices, HotelBookingRoomsServices $hotelBookingRoomsServices)
    {
        $this->hotelBookingRoomsServices = $hotelBookingRoomsServices;
        $this->markupServices = $markupServices;
        $this->hotelRoomDetailServices = $hotelRoomDetailServices;
    }

    public function arabianOryxShoppingAvailibility(Request $req){
        if(request()->method() == 'GET'){
            return Inertia::render('Website/Hotels/ArabianOryxShoppingAvailibilityBooking');
        }else if(request()->method() == 'POST'){
            $bookingId = self::insertBookings($req);
            $hotelPriceAndAvailibility = HotelLibrary::hotelPriceAndAvailibility($req);
            if($hotelPriceAndAvailibility){
                self::sethotelRoomDetails($hotelPriceAndAvailibility['hotel']['rooms'], $req['bckId']);
                return array(
                    'hotelPriceAndAvailibility' => self::__hotelAvailibilityDetails($hotelPriceAndAvailibility),
                    'customerCode' => $hotelPriceAndAvailibility['generalInfo']['customerCode'],
                    'bookingId' => $bookingId,
                    'error' => false
                );
            }else{
                return array(
                    'hotelPriceAndAvailibility' => '',
                    'customerCode' => '',
                    'bookingId' => $bookingId,
                    'error' => true
                );
            }
        }
    }
    public function sethotelRoomDetails($rooms, $bookingId){
        $checkRooms = $this->hotelRoomDetailServices->single([['hotel_booking_id', '=' , $bookingId],['created_at', '>=' , date('Y-m-d')]]);
        if(empty($checkRooms)){
            foreach($rooms['room'] as $room)
            {
                $hotelBookingRoomsData = [
                    'hotel_booking_id' => $bookingId,
                    'room_name' => $room['roomName'],
                    'meal' => $room['meal'],
                    'rate_type' => $room['rateType'],
                    'rate_key' => $room['rateKey'],
                    'status' => $room['status'],
                    'marriage_identifier' => $room['marriageIdentifier'],
                    'reprice' => $room['reprice'],
                    'is_price_breakup_available' => $room['isPriceBreakupAvailable'],
                    'is_cancelation_policy_availble' => $room['isCancelationPolicyAvailble'],
                ];
                $this->hotelRoomDetailServices->store($hotelBookingRoomsData);
            }
        }
    }
    public function insertBookings($data){
        $hotelBookingRoomId = [];
        foreach($data['rateKey'] as $rateKeyIndex => $rateKey){
            $checkRooms = $this->hotelBookingRoomsServices->single([['hotel_booking_id', '=' , $data['bckId']],['room_key', '=' , $rateKey],['created_at', '>=' , date('Y-m-d')]]);
            if(!empty($checkRooms)){
                $hotelBookingRoomId[$rateKeyIndex] = $checkRooms['id'];
            }else{
                $hotelBookingRoomsData = [
                    'hotel_booking_id' => $data['bckId'],
                    'room_key' => $rateKey,
                    'eqtotal_base_fare' => $data['eqgross'],
                    'eqtotal_taxes' => $data['eqtax'],
                    'eqtotal_prices' => $data['eqnet'],
                    'markup' => (!empty($data['mka']) ? $data['mka'] : 0),
                    'markup_type' => (!empty($data['mkt']) ? $data['mkt'] : ''),
                    'total_base_fare' => $data['gross'],
                    'total_taxes' => $data['tax'],
                    'total_prices' => $data['net'],
                    'd_currency' => $data['dCurrency'],
                    'd_currency_rate' => $data['dcurrencyRate'],
                    's_currency' => $data['sCurrency'],
                    's_currency_rate' => $data['sCurrencyRate'],
                ];
                $hotelBookingRoom = $this->hotelBookingRoomsServices->store($hotelBookingRoomsData);
                $hotelBookingRoomId[$rateKeyIndex] = $hotelBookingRoom['id'];
            }
        }
        return $hotelBookingRoomId;
    }

    public function __hotelAvailibilityDetails($hotelRoomDetail){
        $markup = $this->markupServices->fetch(['vendor' => 'Arabian Oryx', 'markup_status' => '1']);
        $guestRooms = array();
        $prices = array();
        foreach($hotelRoomDetail['hotel']['rooms'] as $hotelRoomIndex => $hotelrooms){
            if($hotelRoomIndex == 'room'){
                foreach($hotelrooms as $rooms){
                    $guestRooms[$hotelRoomIndex][] =[
                        "adult" => $rooms['adult'],
                        "children" => $rooms['children'],
                        "roomName" => $rooms['roomName'],
                        "meal" => $rooms['meal'],
                        "rateType" => $rooms['rateType'],
                        "rateKey" => $rooms['rateKey'],
                        "status" => $rooms['status'],
                        "bedTypes" => $rooms['bedTypes'],
                        "roomIndex" => $rooms['roomIndex'],
                        "roomIdentifier" => $rooms['roomIdentifier'],
                        "groupCode" => $rooms['groupCode'],
                        "supplierGroupCode" => $rooms['supplierGroupCode'],
                        "shortCode" => $rooms['shortCode'],
                        "contractType" => $rooms['contractType'],
                        "isCache" => $rooms['isCache'],
                        "minStay" => $rooms['minStay'],
                        "policies" => $rooms['policies'],
                        "group" => $rooms['group'],
                        "guests" => $rooms['guests'],
                        "price" => [
                            "promotions" => $rooms['price']['promotions'],
                            "discount" => $rooms['price']['discount'],
                            "extraBedPrice" => $rooms['price']['extraBedPrice'],
                            "gross" => $rooms['price']['gross'],
                            "net" => $rooms['price']['net'],
                            "tax" => $rooms['price']['tax'],
                            "eqgross" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['gross']) : $rooms['price']['gross']),
                            "eqnet" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['net']) : $rooms['price']['net']),
                            "eqtax" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['tax']) : $rooms['price']['tax']),
                            "taxType" => $rooms['price']['taxType'],
                            "commission" => $rooms['price']['commission'],
                            "isB2C" => $rooms['price']['isB2C'],
                            "isPackage" => $rooms['price']['isPackage'],
                            "isDynamic" => $rooms['price']['isDynamic'],
                            "isExclusiveRate" => $rooms['price']['isExclusiveRate'],
                            "supplierCurrency" => $rooms['price']['supplierCurrency'],
                            "supplierGross" => $rooms['price']['supplierGross'],
                            "supplierTax" => $rooms['price']['supplierTax'],
                            "supplierNet" => $rooms['price']['supplierNet'],
                            "eqsupplierGross" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierGross']) : $rooms['price']['supplierGross']),
                            "eqsupplierTax" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierTax']) : $rooms['price']['supplierTax']),
                            "eqsupplierNet" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierNet']) : $rooms['price']['supplierNet']),
                            "supplierCommission" => $rooms['price']['supplierCommission'],
                            "supplierExtraBedPrice" => $rooms['price']['supplierExtraBedPrice'],
                            "priceBreakdownRules" => $rooms['price']['priceBreakdownRules']
                        ],
                        "marriageIdentifier" => $rooms['marriageIdentifier'],
                        "reprice" => $rooms['reprice'],
                        "isPriceBreakupAvailable" => $rooms['isPriceBreakupAvailable'],
                        "isCancelationPolicyAvailble" => $rooms['isCancelationPolicyAvailble'],
                        "remarks" => $rooms['remarks'],
                        "extraBedCount" => $rooms['extraBedCount'],
                        "inclusions" => $rooms['inclusions'],
                    ];
                    $prices[] = array(
                        "gross" => $rooms['price']['gross'],
                        "net" => $rooms['price']['net'],
                        "tax" => $rooms['price']['tax'],
                        "eqgross" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['gross']) : $rooms['price']['gross']),
                        "eqnet" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['net']) : $rooms['price']['net']),
                        "eqtax" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['tax']) : $rooms['price']['tax']),
                        "supplierGross" => $rooms['price']['supplierGross'],
                        "supplierTax" => $rooms['price']['supplierTax'],
                        "supplierNet" => $rooms['price']['supplierNet'],
                        "eqsupplierGross" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierGross']) : $rooms['price']['supplierGross']),
                        "eqsupplierTax" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierTax']) : $rooms['price']['supplierTax']),
                        "eqsupplierNet" => (!empty($markup) ? self::__calculateMarkup($markup, $rooms['price']['supplierNet']) : $rooms['price']['supplierNet']),
                    );
                }
            }
            
        }
        return array(
            'hotelInfo' =>  [
                "name" => $hotelRoomDetail['hotel']['hotelInfo']['name'],
                "image" => $hotelRoomDetail['hotel']['hotelInfo']['image'],
                "description" => $hotelRoomDetail['hotel']['hotelInfo']['description'],
                "starRating" => $hotelRoomDetail['hotel']['hotelInfo']['starRating'],
                "lat" => $hotelRoomDetail['hotel']['hotelInfo']['lat'],
                "lon" => $hotelRoomDetail['hotel']['hotelInfo']['lon'],
                "add1" => $hotelRoomDetail['hotel']['hotelInfo']['add1'],
                "add2" => $hotelRoomDetail['hotel']['hotelInfo']['add2'],
                "city" => $hotelRoomDetail['hotel']['hotelInfo']['city'],
                "location" => $hotelRoomDetail['hotel']['hotelInfo']['location'],
                "hotelRemarks" => $hotelRoomDetail['hotel']['hotelInfo']['hotelRemarks'],
                "checkinInstruction" => $hotelRoomDetail['hotel']['hotelInfo']['checkinInstruction'],
                "checkOutInstruction" => $hotelRoomDetail['hotel']['hotelInfo']['checkOutInstruction'],
                'customeMarkup' => (!empty($markup) ? ($markup['markup_type'] == 'fixed' ? $markup['converted_value'] : $markup['markup_value']) : ''),
                'customeMarkupType' => (!empty($markup) ? $markup['markup_type'] : '')
            ],
            'rooms' => $guestRooms,
            'prices' => $prices
        );
    }

    public function __calculateMarkup($markup, $hotelAmount){
        $amount = 0;
        if($markup['markup_type'] == 'fixed'){
            $amount += $markup['converted_value'];
        }else{
            $amount +=  round(($hotelAmount * $markup['markup_value'] / 100), 2);
        }
        return round(($amount + $hotelAmount), 2);
    }
}
