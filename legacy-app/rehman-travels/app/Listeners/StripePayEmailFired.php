<?php

namespace App\Listeners;

use App\Events\StripePayEmail;
use PDF;
use App\Mail\NotifyMail;
use Illuminate\Support\Facades\Storage;

class StripePayEmailFired
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  \App\Events\StripePayEmail  $stripePayEmail
     * @return void
     */
    public function handle(StripePayEmail $stripePayEmail)
    {
        try {
            $orderRetrieveProvider = $stripePayEmail->stripePayEmail;
            $flightItinerary = $orderRetrieveProvider['flightItinerary'];
            $itineraryRef = $flightItinerary['flightItineraryInfo']['itineraryRef'];
            $params = json_decode($orderRetrieveProvider['params'],true);
            if(!empty($flightItinerary['persons'])):
                $fullName = $flightItinerary['persons'][0]['lastName'].'/'.$flightItinerary['persons'][0]['firstName'];
                $pdf = PDF::loadView('emails.Ticketing.TicketingPdfEmail', [
                    'flightItinerary' => $orderRetrieveProvider['flightItinerary'],
                    'currencyRate' => $params['currencyRate'],
                    'currencyCode' => $params['currencyCode']
                ]);
                Storage::put("pdf/ticket/{$itineraryRef}.pdf", $pdf->output());
            else:
                $fullName = $orderRetrieveProvider['persons'][0]['lastName'].'/'.$orderRetrieveProvider['persons'][0]['firstName'];
            endif;
            new NotifyMail([
                'view' =>'Ticketing.StripePayEmail',
                'data' => [
                    'params' => $params,
                    'flightItinerary' => $flightItinerary,
                    'stripeClientProvider' => $orderRetrieveProvider['stripeClientProvider']
                ],
                'to' => $orderRetrieveProvider['to'],
                'subject' => "Customer {$fullName} has been Stripe Payment Done Itinerary:",
                'itineraryRef' => $itineraryRef,
                'attach' => true,
                'location'=>'ticket'
            ]);
        } catch (Exception $e) {
            \Log::error("Your Stripe Payment email has not been sent successfuly!, Please try again!. {$itineraryRef}" .$e->getMessage() );
        }
    }
}
