<?php

namespace App\Services\CmsCallBack;

use App\Interfaces\Queries\StudyabroadCallbackInterface;
use App\Models\Queries\StudyabroadCallbackQuery;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class StudyabroadCallbackService extends BaseService implements StudyabroadCallbackInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(StudyabroadCallbackQuery $model){
        $this->model = $model;
    }

}
