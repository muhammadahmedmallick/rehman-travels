<?php

namespace App\Services\CmsCallBack;

use App\Interfaces\Queries\CallBackQueriesInterface;
use App\Models\Queries\CmsCallbackQueries;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class CallbackQueriesService extends BaseService implements CallBackQueriesInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(CmsCallbackQueries $model){
        $this->model = $model;
    }

public function __destruct() {
        DB::disconnect();
    }
}
