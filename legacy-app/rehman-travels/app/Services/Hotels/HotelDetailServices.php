<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelDetailInterface;
use App\Models\Hotels\HotelDetail;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelDetailServices extends BaseService implements HotelDetailInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelDetail $model){
        $this->model = $model;
    }
}
