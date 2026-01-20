<?php

namespace App\Listeners;

use App\Events\FreshLeadGenerator;
use App\Libraries\lead\LeadGeneratorProvider;
use Illuminate\Support\Facades\Storage;

class FreshLeadGeneratorFired
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
     * @param  \App\Events\RefreshAccessToken  $freshLeadGenerator
     * @return void
     */
    public function handle(FreshLeadGenerator $freshLeadGenerator)
    {
        return LeadGeneratorProvider::LeadGenerator($freshLeadGenerator->lead,$freshLeadGenerator->message);
    }
}
