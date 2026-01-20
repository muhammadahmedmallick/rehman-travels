<?php

namespace App\Services\User;

use App\Interfaces\User\UserInterface;
use App\Models\Profile\User;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UserService extends BaseService implements UserInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(User $model){
        $this->model = $model;
    }

}