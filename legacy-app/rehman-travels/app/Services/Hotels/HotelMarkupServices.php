<?php

namespace App\Services\Hotels;

use App\Interfaces\Hotels\HotelMarkupInterface;
use App\Models\Hotels\HotelMarkup;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class HotelMarkupServices extends BaseService implements HotelMarkupInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(HotelMarkup $model){
        $this->model = $model;
    }
}
