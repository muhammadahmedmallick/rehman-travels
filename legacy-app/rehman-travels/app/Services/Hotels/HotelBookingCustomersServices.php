<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelBookingCustomersInterface;
use App\Models\Hotels\HotelBookingCustomers;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelBookingCustomersServices extends BaseService implements HotelBookingCustomersInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelBookingCustomers $model){
        $this->model = $model;
    }
}
