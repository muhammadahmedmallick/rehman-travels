<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelRoomDetailsInterface;
use App\Models\Hotels\HotelRoomDetail;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelRoomDetailServices extends BaseService implements HotelRoomDetailsInterface {
    /**
    * @var Model
    */
    protected $model;

    /**
    * HotelRoomDetail constructor.
    *
    * @param Model $model
    */

    public function __construct(HotelRoomDetail $model){
        $this->model = $model;
    }
}
