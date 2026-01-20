<?php

namespace App\Providers;

use App\Interfaces\BaseInterface;
use App\Services\BaseService;
use App\Interfaces\Umrah\UmrahHotelInterface;
use App\Services\Umrah\UmrahHotelService;
use App\Interfaces\Umrah\UmrahHotelImageInterface;
use App\Services\Umrah\UmrahHotelImageService;
use App\Interfaces\Umrah\UmrahHotelRoomPeriodInterface;
use App\Services\Umrah\UmrahHotelRoomPeriodService;
use App\Interfaces\Umrah\UmrahHotelRoomPriceInterface;
use App\Services\Umrah\UmrahHotelRoomPriceService;
use App\Interfaces\Umrah\UmrahTransportSectorInterface;
use App\Services\Umrah\UmrahTransportSectorService;
use App\Interfaces\Umrah\UmrahVehicleInterface;
use App\Services\Umrah\UmrahVehicleService;
use App\Interfaces\Umrah\UmrahVehiclePriceInterface;
use App\Services\Umrah\UmrahVehiclePriceService;
use App\Interfaces\Umrah\UmrahVisaInterface;
use App\Services\Umrah\UmrahVisaService;
use Illuminate\Support\ServiceProvider;


class UmrahServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void {
        $this->app->bind(BaseInterface::class,BaseService::class);
        $this->app->bind(UmrahHotelInterface::class,UmrahHotelService::class);
        $this->app->bind(UmrahHotelImageInterface::class,UmrahHotelImageService::class);
        $this->app->bind(UmrahHotelRoomPeriodInterface::class,UmrahHotelRoomPeriodService::class);
        $this->app->bind(UmrahHotelRoomPriceInterface::class,UmrahHotelRoomPriceService::class);
        $this->app->bind(UmrahTransportSectorInterface::class,UmrahTransportSectorService::class);
        $this->app->bind(UmrahVehicleInterface::class,UmrahVehicleService::class);
        $this->app->bind(UmrahVehiclePriceInterface::class,UmrahVehiclePriceService::class);
        $this->app->bind(UmrahVisaInterface::class,UmrahVisaService::class);
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void{
        //
    }
}
