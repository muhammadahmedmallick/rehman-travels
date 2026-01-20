<?php

namespace App\Libraries\rest_api;

use Illuminate\Support\Carbon;
use Request;


class AllowOnlyValidInputProvider {

    public static function allowOnlyValidInput($request) {
        if(!array_key_exists('tripType',$request))
            return self::__error('tripType',"there is no tripType");
        elseif(!array_key_exists('departureCode',$request))
            return self::__error('departureCode',"there is no departureCode");
        elseif(!array_key_exists('arrivalCode',$request))
            return self::__error('arrivalCode',"there is no arrivalCode");
        elseif(!array_key_exists('outboundDate',$request))
            return self::__error('outboundDate',"there is no outboundDate");
        elseif(!array_key_exists('inboundDate',$request))
            return self::__error('inboundDate',"there is no inboundDate");
        elseif(!array_key_exists('adultsCount',$request))
            return self::__error('adultsCount',"there is no adultsCount");
        elseif(!array_key_exists('childrenCount',$request))
            return self::__error('childrenCount',"there is no childrenCount");
        elseif(!array_key_exists('infantsCount',$request))
            return self::__error('infantsCount',"there is no infantsCount");
        elseif(!array_key_exists('cabin',$request))
            return self::__error('cabin',"there is no cabin");
        elseif(!array_key_exists('currencyCode',$request))
            return self::__error('currencyCode',"there is no currencyCode");
        else return self::__checkIfInputIsEmptyOrInvalid($request);
    }

    private static function __checkIfInputIsEmptyOrInvalid($request){
        foreach($request as $inputKey => $inputs):
             foreach(explode(",",$inputs) as $input):
                 if(($inputKey == 'departureCode' || $inputKey == 'arrivalCode') && empty($input))
                     return self::__isIfEmpty($inputKey,$input);
                 elseif(($inputKey == 'departureCode' || $inputKey == 'arrivalCode') && !empty($input) && (!preg_match('/^[a-zA-Z]+$/', $input) || strlen($input) != 3))
                     return self::__error($inputKey,"Only string allowed in $inputKey Invalid,length must 3 character ".$input);
                 elseif($inputKey == 'outboundDate' && empty($input))
                     return self::__isIfEmpty($inputKey,$input);
                // elseif(($inputKey == 'outboundDate' || $inputKey == 'inboundDate') && !empty($input) && (!preg_match('/^[0-9-]+$/', $input) || date("Y-m-d",strtotime($input)) == '1970-01-01' || strlen($input) != 10))
                  //   return self::__error($inputKey,"Only Number 0-9- and Date allowed in $inputKey Invalid,length must 10 character ".$input);
                 elseif($inputKey == 'adultsCount' || $inputKey == 'childrenCount' || $inputKey == 'infantsCount')
                     if(empty($input) && $inputKey == 'adultsCount')
                         return self::__isIfEmpty($inputKey,$input);
                     elseif(!empty($input) && !preg_match('/^[0-9]+$/', $input))
                         return self::__error($inputKey,"$inputKey selection is invalid, only number allowed ".$input);
                 elseif(empty($request['cabin']) || !preg_match('/^[a-zA-Z]+$/', $request['cabin']) || strlen($request['cabin']) != 1)
                    return self::__error("cabin","Cabin is empty or Invalid, only String allowed , length must 1 character ".$request['cabin']);
                 elseif(empty($request['currencyCode']) || !preg_match('/^[a-zA-Z]+$/', $request['currencyCode']) || strlen($request['currencyCode']) != 3)
                    return self::__error("currencyCode","Currency Code is empty, Invalid only String allowed , length must 3 character ".$request['currencyCode']);
                 elseif(empty($request['tripType']) || !preg_match('/^[a-zA-Z-]+$/', $request['tripType']))
                    return self::__error("tripType","Trip Type is empty, Invalid only allowed ".$request['tripType']);
                 endforeach;
            endforeach;
    }
    
    public static function allowOnlyValidInputIfOrderCreating($request){
        if(!array_key_exists('departureDate',$request))
            return self::__error('departureDate',"there is no tripType");
        elseif(!array_key_exists('adultsCount',$request))
            return self::__error('adultsCount',"there is no adultsCount");
        elseif(!array_key_exists('childrenCount',$request))
            return self::__error('childrenCount',"there is no childrenCount");
        elseif(!array_key_exists('infantsCount',$request))
            return self::__error('infantsCount',"there is no infantsCount");
        elseif(!array_key_exists('phoneNumber',$request))
            return self::__error('phoneNumber',"there is no phoneNumber");
        elseif(!array_key_exists('email',$request))
            return self::__error('email',"there is no email");
        elseif(!array_key_exists('airType',$request))
            return self::__error('airType',"there is no airType");
        elseif(!array_key_exists('jSessionId',$request))
            return self::__error('jSessionId',"there is no jSessionId");
        elseif(!array_key_exists('vCarrier',$request))
            return self::__error('vCarrier',"there is no vCarrier");
        elseif(!array_key_exists('persons',$request))
            return self::__error('persons',"there is no persons");
        elseif(!array_key_exists('bookingKeys',$request))
            return self::__error('bookingKeys',"there is no bookingKeys");
        elseif(!array_key_exists('bookingInfo',$request))
            return self::__error('bookingInfo',"there is no bookingInfo");
        else return self::__checkIfOrderCreateInputIsEmptyOrInvalid($request);
    }
    
    private static function __checkIfOrderCreateInputIsEmptyOrInvalid($request){
        foreach($request as $inputKey => $input):
            if($inputKey == "email" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == "email" && !empty($input) && !preg_match('/^[_a-zA-Z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/', $input))
                return self::__error($inputKey,"Invalid $inputKey ".$input);
            elseif($inputKey == "phoneNumber" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == "phoneNumber" && !empty($input) && !preg_match('/^[0-9+]+$/', $input))
                return self::__error($inputKey,"Invalid $inputKey ".$input);
            elseif($inputKey == "airType" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == "airType" && !empty($input) && !preg_match('/^[a-zA-Z]+$/', $input))
                return self::__error($inputKey,"Invalid $inputKey ".$input);
            elseif($inputKey == "vCarrier" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == "vCarrier" && !empty($input) && !preg_match('/^[a-zA-Z0-9]+$/', $input))
                return self::__error($inputKey,"Invalid $inputKey ".$input);
            elseif($inputKey == "departureDate" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
           // elseif($inputKey == "departureDate" && !empty($input) && (!preg_match('/^[0-9-]+$/', $input) || date("Y-m-d",strtotime($input)) == '1970-01-01' || strlen($input) != 10))
             //   return self::__error($inputKey,"Only Number 0-9- and Date allowed in $inputKey Invalid,length must 10 character ".$input);
            elseif($inputKey == 'Adult' && empty($input))
                    return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == 'Adult' && !empty($input) && !preg_match('/^[0-9]+$/', $input))
                    return self::__error($inputKey,"$inputKey selection is invalid, only number allowed ".$input);
            elseif($inputKey == 'Child' && !empty($input) && !preg_match('/^[0-9]+$/', $input))
                return self::__error($inputKey,"$inputKey selection is invalid, only number allowed ".$input);
            elseif($inputKey == 'Infant' && !empty($input) && !preg_match('/^[0-9]+$/', $input))
                return self::__error($inputKey,"$inputKey selection is invalid, only number allowed ".$input);
            elseif($inputKey == "persons" && empty($input))
                return self::__isIfEmpty($inputKey,$input);
            elseif($inputKey == "persons" && !empty($input))
                return self::__isValidPersonFeild($input,$request['departureDate']);
        endforeach;
    }
    
    private static function __isValidPersonFeild($persons,$departureDate){
        foreach ($persons['type'] as $personKey => $person):
        if(empty($person))
           return self::__isIfEmpty("type",$person);
        elseif(!empty($person) && !preg_match('/^[a-zA-Z]+$/', $person))
            return self::__error("type","type is invalid, only string allowed ".$person);
        if(empty($persons['nameTitle'][$personKey]))
            return self::__isIfEmpty("nameTitle","nameTitle");
        elseif(!empty($persons['nameTitle'][$personKey]) && !preg_match('/^[a-zA-Z]+$/', $persons['nameTitle'][$personKey]))
            return self::__error("nameTitle","nameTitle is invalid, only string allowed ".$persons['nameTitle'][$personKey]);
        elseif(empty($persons['firstName'][$personKey]))
            return self::__isIfEmpty("firstName","firstName");
        elseif(!empty($persons['firstName'][$personKey]) && !preg_match('/^[a-zA-Z ]+$/', $persons['firstName'][$personKey]))
            return self::__error("firstName","firstName is invalid, only string allowed ".$persons['firstName'][$personKey]);
        elseif(empty($persons['lastName'][$personKey]))
            return self::__isIfEmpty("lastName","lastName");
        elseif(!empty($persons['firstName'][$personKey]) && !preg_match('/^[a-zA-Z ]+$/', $persons['lastName'][$personKey]))
            return self::__error("lastName","lastName is invalid, only string allowed ".$persons['firstName'][$personKey]);
        elseif(empty($persons['dobDate'][$personKey]))
            return self::__isIfEmpty("dobDate","dobDate");
        elseif(!empty($persons['dobDate'][$personKey]) && !preg_match('/^[0-9]+$/', $persons['dobDate'][$personKey]))
            return self::__error("dobDate","date of birth day is invalid ".$persons['dobDate'][$personKey]);
        elseif(empty($persons['dobMonth'][$personKey]))
            return self::__isIfEmpty("dobMonth","dobMonth");
        elseif(!empty($persons['dobMonth'][$personKey]) && !preg_match('/^[0-9]+$/', $persons['dobMonth'][$personKey]))
            return self::__error("dobMonth","date of birth month is invalid ".$persons['dobMonth'][$personKey]);
        elseif(empty($persons['dobYear'][$personKey]))
            return self::__isIfEmpty("dobYear","dobYear");
        elseif(!empty($persons['dobYear'][$personKey]) && !preg_match('/^[0-9]+$/', $persons['dobYear'][$personKey]))
            return self::__error("dobYear","date of birth year is invalid ".$persons['dobYear'][$personKey]);
        else
            $dateOfBirth = $persons['dobDate'][$personKey].'-'.$persons['dobMonth'][$personKey].'-'.$persons['dobYear'][$personKey];
            $dateDiiference = self::__dateDiiference(substr($departureDate,0,10), $dateOfBirth);
            if($person == 'Adult' &&  ($dateDiiference->days < 730 || $dateDiiference->days < 4015))
                return self::__error("Adult","Invalid Adult age ".($persons['lastName'][$personKey]."/".$persons['firstName'][$personKey]).".Adult age must 11 Years:Current age Year: $dateDiiference->y, Months: $dateDiiference->m, Days: $dateDiiference->d,".$dateOfBirth);
            elseif($person == 'Child' &&  ($dateDiiference->days < 730 || $dateDiiference->days > 4015))
                return self::__error("Child","Invalid child age ".($persons['lastName'][$personKey]."/".$persons['firstName'][$personKey]).".Child age must between 2-11 Years:Current age Year: $dateDiiference->y, Months: $dateDiiference->m, Days: $dateDiiference->d,".$dateOfBirth);
            elseif($person == 'Infant' &&  $dateDiiference->days > 730)
                return self::__error("Infant","Invalid infant age ".($persons['lastName'][$personKey]."/".$persons['firstName'][$personKey]).".Infant age must between 0-2 Years:Current age Year: $dateDiiference->y, Months: $dateDiiference->m, Days: $dateDiiference->d,".$dateOfBirth);
        endforeach;
    }

    public static function allowOnlyValidInputIfOrderRetrieve($request){
        if(empty($request['at']))
            return self::__isIfEmpty("airType","airType");
        elseif(!empty($request['at']) && !preg_match('/^[a-zA-Z]+$/', $request['at']))
            return self::__error("airType","airType is invalid, string allowed ".$request['at']);
        elseif(!empty($request['irf']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['irf']))
            return self::__error("itineraryRef","itineraryRef is invalid, string and number allowed ".$request['irf']);
        elseif(!empty($request['irf']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['irf']))
            return self::__error("itineraryRef","itineraryRef is invalid, string and number allowed ".$request['irf']);
        elseif(!empty($request['vc']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['irf']))
            return self::__error("vCarrier","vCarrier is invalid, string and number allowed ".$request['vc']);
        elseif(!empty($request['vc']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['irf']))
            return self::__error("vCarrier","vCarrier is invalid, string and number allowed ".$request['vc']);
        elseif(!empty($request['et']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['irf']))
            return self::__error("echoToken","echoToken is invalid, string and number allowed ".$request['et']);
        elseif(!empty($request['et']) && !preg_match('/^[a-zA-Z0-9]+$/', $request['et']))
            return self::__error("echoToken","echoToken is invalid, string and number allowed ".$request['et']);
        elseif(!empty($request['cc']) && !preg_match('/^[A-Z]+$/', $request['cc']))
            return self::__error("currencyCode","currencyCode is invalid, string allowed ".$request['cc']);
        elseif(!empty($request['cr']) && !preg_match('/^[0-9.]+$/', $request['cr']))
            return self::__error("currencyRate","currencyRate is invalid, number allowed ".$request['cr']);
    }

    private static function __dateDiiference($start, $end) {
        if (!empty($start) && !empty($end)):
            $startDate = new Carbon(date('Y-m-d', strtotime($start)));
            $endDate = new Carbon(date('Y-m-d', strtotime($end)));
            return $startDate->diff($endDate);
        endif;
    }

    private static function __isIfEmpty($inputKey,$input){
        return self::__error($inputKey,"$inputKey is empty ".$input);
    }
    private static function __error($fieldName,$message){
        return  '{"input":"true","error":"'.$message.'"}';
    }
}
