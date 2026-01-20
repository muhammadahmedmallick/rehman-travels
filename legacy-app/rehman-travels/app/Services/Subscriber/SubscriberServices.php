<?php

namespace App\Services\Subscriber;

use App\Interfaces\Subscriber\SubscriberInterface;
use App\Models\Subscriber\Subscriber;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class SubscriberServices extends BaseService implements SubscriberInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(Subscriber $model){
        $this->model = $model;
    }

}
