<?php

namespace App\Services\Banks;

use App\Interfaces\Banks\BankDetailInterface;
use App\Models\Banks\BankDetail;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class BankDetailServices extends BaseService implements BankDetailInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(BankDetail $model){
        $this->model = $model;
    }

}
