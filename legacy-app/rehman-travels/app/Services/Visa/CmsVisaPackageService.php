<?php

namespace App\Services\Visa;

use App\Interfaces\Visa\CmsVisaPackageInterface;
use App\Models\Visa\CmsVisaPackage;
use App\Models\Profile\User;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class CmsVisaPackageService extends BaseService implements CmsVisaPackageInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(CmsVisaPackage $model){
        $this->model = $model;
    }



//    public function createdBy(){
////        return $this->belongsTo(User::class,UmrahHotel::class,'createdById','id');
//    }


}
