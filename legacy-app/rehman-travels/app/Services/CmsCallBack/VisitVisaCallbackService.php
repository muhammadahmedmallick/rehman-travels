<?php

namespace App\Services\CmsCallBack;

use App\Interfaces\Queries\VisitVisaCallbackInterface;
use App\Models\Queries\VisitvisaCallbackQuery;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class VisitVisaCallbackService extends BaseService implements VisitVisaCallbackInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(VisitvisaCallbackQuery $model){
        $this->model = $model;
    }

}
