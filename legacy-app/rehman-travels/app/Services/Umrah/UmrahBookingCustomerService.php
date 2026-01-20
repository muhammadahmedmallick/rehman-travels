<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahBookingCustomerInterface;
use App\Models\Umrah\UmrahBookingCustomer;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahBookingCustomerService extends BaseService implements UmrahBookingCustomerInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahBookingCustomer $model){
        $this->model = $model;
    }
}
