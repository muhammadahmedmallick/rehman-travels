<?php

namespace App\Services\Customer;

use App\Interfaces\Customer\CustomerInterface;
use App\Models\Customers;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class CustomerService extends BaseService implements CustomerInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(Customers $model){
        $this->model = $model;
    }

}