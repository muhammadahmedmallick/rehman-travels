<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahHotelImageInterface;
use App\Models\Umrah\UmrahHotelImage;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahHotelImageService extends BaseService implements UmrahHotelImageInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahHotelImage $model){
        $this->model = $model;
    }

}
