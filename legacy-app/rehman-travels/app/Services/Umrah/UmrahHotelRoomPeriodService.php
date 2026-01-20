<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahHotelRoomPeriodInterface;
use App\Models\Umrah\UmrahHotelRoomPeriod;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahHotelRoomPeriodService extends BaseService implements UmrahHotelRoomPeriodInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahHotelRoomPeriod $model){
        $this->model = $model;
    }

}
