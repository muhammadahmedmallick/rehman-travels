<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahBookingInterface;
use App\Models\Umrah\UmrahBooking;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahBookingService extends BaseService implements UmrahBookingInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahBooking $model){
        $this->model = $model;
    }

}
