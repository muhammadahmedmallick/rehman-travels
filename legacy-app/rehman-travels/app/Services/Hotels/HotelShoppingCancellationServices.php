<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelShoppingCancellationsInterface;
use App\Models\Hotels\HotelCancellations;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelShoppingCancellationServices extends BaseService implements HotelShoppingCancellationsInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelCancellations $model){
        $this->model = $model;
    }
}
