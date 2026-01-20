<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelShoppingConfirmationInterface;
use App\Models\Hotels\HotelConfirmations;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelShoppingConfirmationServices extends BaseService implements HotelShoppingConfirmationInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelConfirmations $model){
        $this->model = $model;
    }
}
