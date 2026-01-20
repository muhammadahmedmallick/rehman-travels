<?php

namespace App\Helper;

class UmrahHelper{
    
    public static function __checkHotelType($hotelType)
    {
        $HType = "";
        if ($hotelType == 2) :
            $HType = "2 Stars";
        elseif ($hotelType == 3) :
            $HType = "3 Stars";
        elseif ($hotelType == 4) :
            $HType = "4 Stars";
        elseif ($hotelType == 5) :
            $HType = "5 Stars";
        elseif ($hotelType == 5) :
            $HType = "5 Stars";
        else:
            $HType = str_replace('-', ' ', $hotelType);
        endif;

        return $HType;
    }
    public static function __checkBasis($hotelBasis)
    {
        $RTypeF = "";
        if ($hotelBasis == "BB") :
            $RTypeF = "With Break Fast";
        elseif ($hotelBasis == "HB") :
            $RTypeF = "BreakFast,Lunch OR Dinner";
        elseif ($hotelBasis == "FB") :
            $RTypeF = "BreakFast,Lunch AND Dinner";
        else :
            $RTypeF = "Without Break Fast";
        endif;

        return $RTypeF;
    }
    public static function __checkCity($cityId)
    {
        if ($cityId == 1) :
            $cityFullName = 'Islamabad';
        elseif ($cityId == 2) :
            $cityFullName = 'Karachi';
        elseif ($cityId == 3) :
            $cityFullName = 'Lahore';
        elseif ($cityId == 4) :
            $cityFullName = 'Peshawar';
        elseif ($cityId == 5) :
            $cityFullName = 'Mirpur';
        else :
            $cityFullName = 'Others';
        endif;
        return $cityFullName;
    }

}