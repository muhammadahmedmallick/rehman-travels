<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahVehicleInterface;
use App\Models\Umrah\UmrahVehicle;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahVehicleService extends BaseService implements UmrahVehicleInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahVehicle $model){
        $this->model = $model;
    }

}
