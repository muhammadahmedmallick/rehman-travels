<?php

namespace App\Services\Site;

use App\Interfaces\Site\ParentPageInterface;
use App\Models\Site\ParentPage;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ParentPageService extends BaseService implements ParentPageInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(ParentPage $model){
        $this->model = $model;
    }
    
    public function __destruct() {
        DB::disconnect();
    }

}
