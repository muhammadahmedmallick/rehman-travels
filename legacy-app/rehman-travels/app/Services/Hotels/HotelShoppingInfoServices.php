<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelShoppingInfoInterface;
use App\Models\Hotels\HotelShoppingInfo;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelShoppingInfoServices extends BaseService implements HotelShoppingInfoInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelShoppingInfo $model){
        $this->model = $model;
    }
}
