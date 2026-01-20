<?php

namespace App\Listeners;

use App\Events\AdvancedCalendarSearch;
use App\Libraries\rest_api\CheapestCalendarFareProvider;
use Illuminate\Support\Facades\Storage;

class AdvancedCalendarSearchFired
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
     * @param  \App\Events\AdvancedCalendarSearch  $advancedCalendarSearch
     * @return void
     */
    public function handle(AdvancedCalendarSearch $advancedCalendarSearch)
    {
        $query = $advancedCalendarSearch->request->query() ?? [];
         CheapestCalendarFareProvider::calendarFareReponse($query);
    }
}
