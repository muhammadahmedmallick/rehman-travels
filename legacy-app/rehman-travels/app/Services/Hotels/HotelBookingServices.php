<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelBookingInterface;
use App\Models\Hotels\HotelBookings;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelBookingServices extends BaseService implements HotelBookingInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelBookings $model){
        $this->model = $model;
    }
}
