<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Libraries\rest_api\OrderRetrieveProvider;
use App\Libraries\rest_api\AirFlightItineraryProvider;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Events\TicketingEmail;

class OrderRetrieveJobProvider implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;


    protected $flightItinerary = array();


    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($flightItinerary){
        $this->flightItinerary = $flightItinerary;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        try {
            $orderRetrieveProvider = OrderRetrieveProvider::cheapestFareOrderRetrieveReponse($this->flightItinerary);
            Storage::put('OrderRetrieve/' . $this->flightItinerary['itineraryRef'] . '.json', json_encode($orderRetrieveProvider));
            try {
                if(!empty($orderRetrieveProvider)):
                    event(new TicketingEmail([
                        "unlink" => $this->flightItinerary['unlink'],
                        "to" => $this->flightItinerary['to'],
                        "subject" => $this->flightItinerary['subject'],
                        "body" =>  $this->flightItinerary['body'],
                        "params" => $this->flightItinerary['params'],
                        "airType" => $this->flightItinerary['airType'],
                        "itineraryRef" => $this->flightItinerary['itineraryRef'],
                        "reference" => $this->flightItinerary['reference'],
                        "echoToken" => $this->flightItinerary['echoToken'],
                        "vCarrier" => $this->flightItinerary['vCarrier'],
                        "jSessionId" => $this->flightItinerary['jSessionId']
                    ]));
                    try {
                        AirFlightItineraryProvider::flightItinerary($this->flightItinerary['itineraryRef'],$this->flightItinerary['params'],$orderRetrieveProvider);
                    } catch (Exception $e) {
                        \Log::error('Not  Add AirFlightItineraryProvider successfuly!, Please try again!.'. $e->getMessage());
                    }
                endif;
            } catch (Exception $e) {
                \Log::error('Event Ticketing Email has not called successfuly!, Please try again!.'. $e->getMessage());
            }
        } catch (Exception $e) {
            \Log::error('Order Retrieve Provider has not  successfuly!, Please try again!.'. $e->getMessage());
        }
    }

}
