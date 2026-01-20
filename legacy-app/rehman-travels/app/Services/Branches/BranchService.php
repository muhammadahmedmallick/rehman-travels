<?php

namespace App\Services\Branches;

use App\Interfaces\Branches\BranchInterface;
use App\Models\Branches\Branch;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class BranchService extends BaseService implements BranchInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(Branch $model){
        $this->model = $model;
    }

}