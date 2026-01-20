<?php

namespace App\Services\Tour;

use App\Interfaces\Tour\PakistanTourPackageInterface;
use App\Models\Tour\TourPackage;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class PakistanTourPackageService extends BaseService implements PakistanTourPackageInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * ParentPage constructor.
     *
     * @param Model $model
     */

    public function __construct(TourPackage $model){
        $this->model = $model;
    }
}
