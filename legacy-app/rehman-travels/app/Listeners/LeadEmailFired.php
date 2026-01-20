<?php

namespace App\Listeners;

use App\Events\LeadEmail;
use PDF;
use Illuminate\Support\Facades\Storage;
use App\Mail\NotifyLeadMail;
use Illuminate\Support\Facades\View;

class LeadEmailFired
{

    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {

    }

    /**
     * Handle the event.
     *
     * @param \App\Events\LeadEmail $leadEmailEventProvider
     * @return void
     */
    public function handle(LeadEmail $leadEmailEventProvider)
    {
       try {
            $emailEventProvider = $leadEmailEventProvider->leadEmailEventProvider;
              try {
                    if (!empty($emailEventProvider['to'])):
                        foreach ($emailEventProvider['to'] as $key => $to):
                            new NotifyLeadMail([
                                'view' => "",
                                'to' => 'khalidjavid@exalted.pk',
                                'toTitle' => ($key == 0 ? $emailEventProvider['name'][0] : $emailEventProvider['name'][1]),
                                'from' => 'bdm@rehmantravel.com',
                                'fromTitle' => ($key == 0 ? $emailEventProvider['name'][1] : $emailEventProvider['name'][0]),
                                'cc' => ($key == 0 ? true : false),
                                'subject' => ($key == 0 ? $emailEventProvider['subject'][0] : $emailEventProvider['subject'][1]),
                                'attach' => false,
                                'location' => $emailEventProvider['location'],
                                'fileName' => $emailEventProvider['fileName'],
                                'data' =>  [
                                    'body' => $emailEventProvider['body']['request']    
                                ],
                            ]);
                        endforeach;
                    endif;
               } catch (Exception $e) {
                   \Log::info('Technical issue occurred,Your are not able to sent Flight Query successfuly ! .' . $e->getMessage());
               }
       } catch (\Exception $e) {
           \Log::info('Technical issue occurred,Your are not able to create Lead Email!.' . $e);
        }
    }

}
