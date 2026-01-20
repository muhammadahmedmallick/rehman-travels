<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahHotelInterface;
use App\Models\Umrah\UmrahHotel;
use App\Models\Profile\User;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahHotelService extends BaseService implements UmrahHotelInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahHotel $model){
        $this->model = $model;
    }



//    public function createdBy(){
////        return $this->belongsTo(User::class,UmrahHotel::class,'createdById','id');
//    }


}
