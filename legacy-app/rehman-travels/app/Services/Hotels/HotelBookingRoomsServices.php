<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelBookingRoomsInterface;
use App\Models\Hotels\HotelBookingRooms;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelBookingRoomsServices extends BaseService implements HotelBookingRoomsInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelBookingRooms $model){
        $this->model = $model;
    }
}
