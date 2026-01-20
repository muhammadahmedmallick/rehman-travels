<?php

namespace App\Jobs;

use App\Events\CheapestFareShoppingEventProvider;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Libraries\rest_api\ServiceProvider;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class CheapestFareShoppingJobProvider implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    protected $cheapestFareShopping = array();
    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($cheapestFareShopping)
    {
        $this->cheapestFareShopping = $cheapestFareShopping;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $serviceProvider = ServiceProvider::doRequest("POST", $this->cheapestFareShopping['shoppingType'], $this->cheapestFareShopping['payload']);
        Storage::put('AirShopping/' . $this->cheapestFareShopping['shoppingType'] . '.json', json_encode($serviceProvider));
        return "<script>
        localStorage.setItem('shoppingType', 'serviceProvider');
      </script>";
        return Inertia::render('FrontEnd/Ticketing/CheapestFareFlight');
//          return Inertia::share('FrontEnd/Ticketing/CheapestFareFlight',['emirateShoppings' => json_encode($cheapestFareShopping)]);
//       if(!empty($cheapestFareShopping)):
//           event(new CheapestFareShoppingEventProvider([
//               "cheapestFareShopping" => $cheapestFareShopping,
//               "shoppingType" => $this->cheapestFareShopping['shoppingType']
//           ]));
//       endif;

    }
}
