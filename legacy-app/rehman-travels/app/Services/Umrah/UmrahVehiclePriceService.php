<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahVehiclePriceInterface;
use App\Models\Umrah\UmrahVehiclePrice;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahVehiclePriceService extends BaseService implements UmrahVehiclePriceInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahVehiclePrice $model){
        $this->model = $model;
    }

}
