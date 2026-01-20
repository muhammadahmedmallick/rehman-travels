<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahHotelRoomPriceInterface;
use App\Models\Umrah\UmrahHotelRoomPrice;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahHotelRoomPriceService extends BaseService implements UmrahHotelRoomPriceInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahHotelRoomPrice $model){
        $this->model = $model;
    }

}
