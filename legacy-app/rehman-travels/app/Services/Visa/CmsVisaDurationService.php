<?php

namespace App\Services\Visa;

use App\Interfaces\Visa\CmsVisaDurationInterface;
use App\Models\Visa\CmsVisaDuration;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class CmsVisaDurationService extends BaseService implements CmsVisaDurationInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(CmsVisaDuration $model){
        $this->model = $model;
    }
}
