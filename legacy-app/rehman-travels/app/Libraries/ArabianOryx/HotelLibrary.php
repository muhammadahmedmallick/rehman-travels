<?php

namespace App\Libraries\ArabianOryx;

use App\Libraries\rest_api\ServiceProvider;
use Illuminate\Support\Collection;

class HotelLibrary
{

    public static function hotelSearch($req)
    {
        $xmlhotelSearchPayLoad = '';
        $xmlhotelSearchPayLoad .= '<HotelSearchRequest>
            <SearchParameter>
                <DestinationCode>' . $req['destinationCode'] . '</DestinationCode>
                <CountryCode>' . $req['countryCode'] . '</CountryCode>
                <CheckInDate>' . (date('Y-m-d', strtotime($req['checkInDate']))) . 'T00:00:00</CheckInDate>
                <CheckOutDate>' . (date('Y-m-d', strtotime($req['checkOutDate']))) . 'T00:00:00</CheckOutDate>
                <Currency>USD</Currency>
                <Nationality>' . $req['nationality'] . '</Nationality>';
                $xmlhotelSearchPayLoad .= '<Rooms>
                    '.self::xmlRoomsDetails($req['personsDetails']).'
                </Rooms>';
                $xmlhotelSearchPayLoad .= '
                <TassProInfo>
                    <CustomerCode>3172</CustomerCode>
                    <RegionID>123</RegionID>
                </TassProInfo>
            </SearchParameter>
        </HotelSearchRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/Search';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelSearchPayLoad);
    }

    public static function hotelRoomDetail($req){
        $xmlhotelRoomDetailPayLoad = '<HotelRoomDetailRequest SessionId="' . $req['hotelSessionId'] . '">
                <SearchParameter>
                    <HotelCode>' . $req['hotelCode'] . '</HotelCode>
                    <Currency>USD</Currency>';
        $xmlhotelRoomDetailPayLoad .= '<Rooms>
                    '.self::xmlRoomsDetails($req['personsDetails']).'
                    </Rooms>
                </SearchParameter>
            </HotelRoomDetailRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/RoomDetails';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelRoomDetailPayLoad);
    }

    public static function hotelPriceAndAvailibility($req)
    {
        $xmlhotelPriceAndAvailibilityPayLoad = '';
        $xmlhotelPriceAndAvailibilityPayLoad .= '<HotelPriceAndAvailibilityRequest SessionId="' . $req['hotelSessionId'] . '">
                            <SearchParameter>
                                <HotelCode>' . $req['hotelCode'] . '</HotelCode>
                                <GroupCode>' . $req['groupCode'] . '</GroupCode>
                                <DestinationCode>' . $req['destinationCode'] . '</DestinationCode>
                                <Currency>USD</Currency>
                                <RateKeys>';
        foreach ($req['rateKey'] as $key): $xmlhotelPriceAndAvailibilityPayLoad .= '<RateKey>' . $key . '</RateKey>'; endforeach;
        $xmlhotelPriceAndAvailibilityPayLoad .= '</RateKeys>
                        </SearchParameter>
                    </HotelPriceAndAvailibilityRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/Reprice';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelPriceAndAvailibilityPayLoad);
    }

    // public static function __hotelBooking($req){
    //     $hotelPayload = $req['payload'];
    //     $availablePrices = $req['availablePrices'];
    //     $xmlhotelBookingPayLoad = '<HotelBookingRequest SessionId="' . $hotelPayload['hotelSessionId'] . '">
    //         <HotelCode>' . $hotelPayload['hotelCode'] . '</HotelCode>
    //         <GroupCode>' . $hotelPayload['groupCode'] . '</GroupCode>
    //         <DestinationCode>' . $hotelPayload['destinationCode'] . '</DestinationCode>
    //         <Currency>USD</Currency>
    //         <Nationality>' . $hotelPayload['countryCode'] . '</Nationality>
    //         <CustomerRefNumber>'.$hotelPayload['bckId'].'</CustomerRefNumber>
    //         <Rooms>
    //             <Room RoomIdentifier="1">
    //                 <RateKey>'.$hotelPayload['rateKey'][0].'</RateKey>
    //                 <Guests>
    //                     <Guest IsLeadPAX="true" Type="ADULT">
    //                         <Title Code="">Mr</Title>
    //                         <FirstName>Test</FirstName>
    //                         <LastName>TestBabar Hussain</LastName>
    //                         <Age>0</Age>
    //                     </Guest>
    //                 </Guests>
    //                 <Price Gross="'.$availablePrices[0]['gross'].'" Net="'.$availablePrices[0]['net'].'" Tax="'.$availablePrices[0]['tax'].'" />
    //             </Room>
    //         </Rooms>
    //     </HotelBookingRequest>';
    //     $url = 'http://uatapi.giinfotech.ae/api/Hotel/Book';
    //     dd($xmlhotelBookingPayLoad);
    //     return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelBookingPayLoad);
    // }

    public static function hotelBooking($req){
        $hotelPayload = $req['payload'];
        $availablePrices = $req['availablePrices'];
        $xmlhotelBookingPayLoad = "";
        $xmlhotelBookingPayLoad .= '<HotelBookingRequest SessionId="' . $hotelPayload['hotelSessionId'] . '">
                <HotelCode>' . $hotelPayload['hotelCode'] . '</HotelCode>
                <GroupCode>' . $hotelPayload['groupCode'] . '</GroupCode>
                <DestinationCode>' . $hotelPayload['destinationCode'] . '</DestinationCode>
                <Currency>USD</Currency>
                <Nationality>' . $hotelPayload['countryCode'] . '</Nationality>
                <CustomerRefNumber>' . (!empty($hotelPayload['customerCode']) ? $hotelPayload['customerCode'] : $hotelPayload['bckId']) . '</CustomerRefNumber>
                <Rooms>';
                foreach(range(0, ($req['payload']['rooms']-1)) as $payloadIndex){
                    $xmlhotelBookingPayLoad .= '
                        <Room RoomIdentifier="'.($payloadIndex+1).'">
                            <RateKey>' . ($req['payload']['rooms'] > 1 ? $hotelPayload['rateKey'][$payloadIndex] : $hotelPayload['rateKey'][0]  ) . '</RateKey>
                            <Guests>';
                            foreach($req['persons'][$payloadIndex] as $personIndex => $persons){
                                $xmlhotelBookingPayLoad .= 
                                '
                                <Guest IsLeadPAX="'.($persons['isLeadPax'] != 0 && $payloadIndex == 0 ? 'true' : 'false' ).'" Type="'.strtoupper($persons['type']).'">
                                    <Title Code="">'.($persons['title'] == 'Ms' ? 'Mrs' : $persons['title']).'</Title>
                                    <FirstName>'.$persons['firstName'].'</FirstName>
                                    <LastName>'.$persons['lastName'].'</LastName>
                                    <Age>'.$persons['age'].'</Age>
                                </Guest>';
                            }
                            $xmlhotelBookingPayLoad .= '
                            </Guests>
                            <Price Gross="'.($req['payload']['rooms'] > count($req['bookingIds']) ? $availablePrices[0]['gross'] : $availablePrices[$payloadIndex]['gross']).'" Net="'.($req['payload']['rooms'] > count($req['bookingIds']) ? $availablePrices[0]['net'] : $availablePrices[$payloadIndex]['net']).'" Tax="'.($req['payload']['rooms'] > count($req['bookingIds']) ? $availablePrices[0]['tax'] : $availablePrices[$payloadIndex]['tax']).'" />
                        </Room>';
                }
                $xmlhotelBookingPayLoad .= '
                </Rooms>
            </HotelBookingRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/Book';
        // return $xmlhotelBookingPayLoad;
        // return '24516-2654651-15415684';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelBookingPayLoad);
    }

    public static function hotelShoppingCancellation($req){
        $collection = new Collection();
        $xmlhotelShoppingCancellationPayLoad = '';
        $xmlhotelShoppingCancellationPayLoad .= '
            <HotelCancelationRequest SessionId="'.$req['hotelSessionId'].'">
            <Currency>USD</Currency>
            <ADSConfirmationNumber>'.$req['cfrm'].'</ADSConfirmationNumber>
            <CancelRooms>';
            foreach(range(0, ($req['rooms']-1)) as $payloadIndex){
            $xmlhotelShoppingCancellationPayLoad .= '
            <CancelRoom RoomIdentifier="'.($payloadIndex+1).'" />';
            }
            $xmlhotelShoppingCancellationPayLoad .= '
            </CancelRooms>
            </HotelCancelationRequest>';
            $url = 'http://uatapi.giinfotech.ae/api/Hotel/Cancel';
            return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelShoppingCancellationPayLoad);
    }

    public static function hotelCancellationPolicy($req){
        $xmlhotelCancellationPolicyPayLoad = '';
        $xmlhotelCancellationPolicyPayLoad .= '<HotelCancellationPolicyRequest SessionId="' . $req['hotelSessionId'] . '">
            <SearchParameter>
                <HotelCode>' . $req['hotelCode'] . '</HotelCode>
                <GroupCode>' . $req['groupCode'] . '</GroupCode>
                <DestinationCode>' . $req['destinationCode'] . '</DestinationCode>
                <Currency>USD</Currency>
                <RateKeys><RateKey>' . $req['rateKey']  . '</RateKey></RateKeys>';
        $xmlhotelCancellationPolicyPayLoad .= '
            </SearchParameter>
        </HotelCancellationPolicyRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/CancellationPolicy';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelCancellationPolicyPayLoad);
    }

    public static function hotelPriceBreakup($req){
        $xmlhotelPriceBreakupPayLoad = '';
        $xmlhotelPriceBreakupPayLoad .= '<HotelPriceBreakupRequest SessionId="' . $req['hotelSessionId'] . '">
            <SearchParameter>
                <HotelCode>' . $req['hotelCode'] . '</HotelCode>
                <GroupCode>' . $req['groupCode'] . '</GroupCode>
                <DestinationCode>' . $req['destinationCode'] . '</DestinationCode>
                <Currency>USD</Currency>
                <RateKeys>';
                foreach ($req['rateKey'] as $key): $xmlhotelPriceBreakupPayLoad .= '<RateKey>' . $key . '</RateKey>'; endforeach;
        $xmlhotelPriceBreakupPayLoad .= '</RateKeys>
            </SearchParameter>
        </HotelPriceBreakupRequest>';
        $url = 'http://uatapi.giinfotech.ae/api/Hotel/PriceBreakup';
        return ServiceProvider::doHotelRequest('POST', $url, $xmlhotelPriceBreakupPayLoad);
    }
    
    public static function xmlRoomsDetails($personsDetails){
        $totalRooms = "";
        foreach($personsDetails as $personsDetailIndex => $personsDetail){
            $totalRooms .= '
                <Room RoomIdentifier="'. $personsDetailIndex+1 .'">
                    <Adult>'.$personsDetail['adultsCount'].'</Adult>';
                    if($personsDetail['childrenCount'] > 0){
                        $totalRooms .= '
                        <Children Count="'.$personsDetail['childrenCount'].'">';
                        foreach(range(1, $personsDetail['childrenCount']) as $child){
                            $totalRooms .= '<ChildAge Identifier="'.$child.'">'.$personsDetail['age'][$child-1].'</ChildAge>';
                        }
                        $totalRooms .= '</Children>';
                    }
            $totalRooms .= '</Room>';
        };
        \Log::info('rooms', ['roomsDetails' => $totalRooms]);
        return $totalRooms;
    }
}