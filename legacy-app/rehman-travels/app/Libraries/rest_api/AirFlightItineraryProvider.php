<?php

namespace App\Libraries\rest_api;

use App\Models\Ticketing\FlightItineraryInfo;
use App\Models\Ticketing\FlightItineraryPersonInfo;
use App\Models\Ticketing\FlightItineraryLegInfo;

class AirFlightItineraryProvider
{
    public static function flightItinerary($itineraryRef, $param, $orderRetrieveProvider)
    {
        try {
            $flightItinerary = $orderRetrieveProvider['flightItinerary'];
            if (!empty($flightItinerary)):
                if (!empty($flightItinerary['flightItineraryInfo']['status']) && $flightItinerary['flightItineraryInfo']['status'] == 'Cancel'):
                    FlightItineraryInfo::updateWhenItineraryRefIsCancelled($flightItinerary);
                else:
                    $flightItineraryPersonInfo = FlightItineraryPersonInfo::where('itineraryRef', $itineraryRef)->first();
                    if (empty($flightItineraryPersonInfo->itineraryRef) && empty($flightItinerary['persons'][0]['ticketNumber'])):
                        $itineraryRef = $flightItinerary['flightItineraryInfo']['itineraryRef'];
                        FlightItineraryInfo::__update($param, $flightItinerary);
                        FlightItineraryPersonInfo::__create($param, $flightItinerary['persons'], $flightItinerary['baggage'], (!empty($flightItinerary['markupAndMarkdowns']) ? $flightItinerary['markupAndMarkdowns'] : array()));
                        FlightItineraryLegInfo::__create($itineraryRef, $flightItinerary['legs']);
                        if ($flightItinerary['flightItineraryInfo']['status'] == 'Cancel'):
                            FlightItineraryInfo::updateWhenItineraryRefIsCancelled($flightItinerary);
                        endif;
                    elseif (!empty($flightItineraryPersonInfo->itineraryRef) && !empty($flightItinerary['persons'][0]['ticketNumber'])):
                        FlightItineraryPersonInfo::__updateTicketNumber($flightItinerary['persons'], $itineraryRef, '1', (!empty($flightItinerary['markupAndMarkdowns']) ? $flightItinerary['markupAndMarkdowns'] : array()));
                    endif;
                endif;
            endif;
        } catch (\Exception $e) {
            return response()->json([
                "errorType" => "true",
                "error" => "500",
                "responseError" => "Internal Server Error"
            ]);
        }
    }

    private static function __isTicketStatus($ticketStatus)
    {
        $ticketStatuses = array("TE" => "TE", "TV" => "TV", "TR" => "TR");
        return array_search($ticketStatus, $ticketStatuses);
    }
}
