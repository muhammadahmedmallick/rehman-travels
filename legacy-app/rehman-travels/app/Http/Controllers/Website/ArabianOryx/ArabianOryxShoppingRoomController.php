<?php

namespace App\Http\Controllers\Website\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Libraries\ArabianOryx\HotelLibrary;
use App\Services\Hotels\HotelBookingServices;
use App\Services\Hotels\HotelDetailServices;
use App\Services\Hotels\HotelMarkupServices;
use App\Services\Hotels\HotelShoppingInfoServices;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Inertia\Inertia;

class ArabianOryxShoppingRoomController extends Controller
{
    protected $hotelShoppingInfoServices;
    protected $hotelBookingServices;
    protected $hotelDetailServices;
    protected $markupServices;
    public function __construct(HotelMarkupServices $markupServices, HotelShoppingInfoServices $hotelShoppingInfoServices, HotelBookingServices $hotelBookingServices, HotelDetailServices $hotelDetailServices)
    {
        $this->hotelShoppingInfoServices = $hotelShoppingInfoServices;
        $this->hotelBookingServices = $hotelBookingServices;
        $this->hotelDetailServices = $hotelDetailServices;
        $this->markupServices = $markupServices;
    }
    public function arabianOryxShoppingRooms(Request $req){
        if(request()->method() == 'GET'){
            return Inertia::render('Website/Hotels/ArabianOryxShoppingRoomListing');
        }else if(request()->method() == 'POST'){
            $markup = $this->markupServices->fetch(['vendor' => 'Arabian Oryx', 'markup_status' => '1']);
            $isBookingId = self::insertLead($req);
            $hotelRoomDetail = HotelLibrary::hotelRoomDetail($req);
            if($hotelRoomDetail['hotel']['rooms']){
                $guestRooms = array();
                foreach($hotelRoomDetail['hotel']['rooms'] as $hotelRoomIndex => $hotelrooms){
                    if($hotelRoomIndex == 'room'){
                        foreach($hotelrooms as $rooms){
                            $guestRooms[$hotelRoomIndex][] = [
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
                                    "eqtax" => (!empty($markup)? self::__calculateMarkup($markup, $rooms['price']['tax']) : $rooms['price']['tax']),
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
                        }
                    }
                    
                }
                return array(
                    'hotelDetails' => [
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
                        'rooms' => $guestRooms
                    ],
                    'bkingId' => $isBookingId
                );
            }else{
                return array(
                    'hotelDetails' => '',
                    'bkingId' => $isBookingId
                );
            }
        }
    }
    public function insertLead($data){
        $hoteId = self::insertHotel($data);
        $hotelShoppingInfoData = [
            'country_code'=> $data['countryCode'],
            'destination_code'=> $data['destinationCode'],
            'group_code'=> $data['groupCode'],
            'hotel_detail_id'=> $hoteId,
        ];
        $hotelShoppingInfoId = $this->hotelShoppingInfoServices->store($hotelShoppingInfoData);
        if($hotelShoppingInfoId){
            $hotelBookingData = [
                'hotel_shopping_info_id' => $hotelShoppingInfoId['id'],
                'hotel_session_id' => $data['hotelSessionId'],
                'check_in' => $data['checkInDate'],
                'check_out' => $data['checkOutDate'],
                't_nights' => $data['totalNights'],
                't_rooms' => $data['rooms'],
                't_adults' => $data['adultCount'],
                't_childs' => $data['childCount'],
                'nationality' => $data['nationality'],
            ];
            $hotelBookingId = $this->hotelBookingServices->store($hotelBookingData);
            return $hotelBookingId['id'];
        }
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

    public function insertHotel($hotelData){
        $hotelExistData = $this->hotelDetailServices->fetch(['code' => $hotelData['hotelDetails']['cdi']]);
        if($hotelExistData){
            $address = $hotelData['hotelDetails']['ad1'].' '.$hotelData['hotelDetails']['ad2'];
            $hotelRec = [
                'name' => $hotelData['hotelDetails']['htl'],
                'code' => $hotelData['hotelDetails']['cdi'],
                'address' => str_replace(',', '', $address),
                'vendor' => 'Arabian Oryx',
                'city' => $hotelData['hotelDetails']['cty'],
                'star_rating' => $hotelData['hotelDetails']['sr'],
                'created_by' => '105',
            ];
            $this->hotelDetailServices->update($hotelExistData['id'], $hotelRec);
            return $hotelExistData['id'];
        }else{
            $address = $hotelData['hotelDetails']['ad1'].' '.$hotelData['hotelDetails']['ad2'];
            $hotelRec = [
                'name' => $hotelData['hotelDetails']['htl'],
                'code' => $hotelData['hotelDetails']['cdi'],
                'address' => str_replace(',', '', $address),
                'vendor' => 'Arabian Oryx',
                'city' => $hotelData['hotelDetails']['cty'],
                'star_rating' => $hotelData['hotelDetails']['sr'],
                'created_by' => '105',
            ];
            $hotel = $this->hotelDetailServices->store($hotelRec);
            return $hotel['id'];
        }
    }
}
