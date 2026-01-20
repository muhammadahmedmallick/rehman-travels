<?php

namespace App\Services\Site;

use App\Interfaces\Site\ContentPageInterface;
use App\Models\Site\ContentPage;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ContentPageService extends BaseService implements ContentPageInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(ContentPage $model){
        $this->model = $model;
    }

  public function __destruct() {
        DB::disconnect();
    }
}
