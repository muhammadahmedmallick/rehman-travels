<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahVisaInterface;
use App\Models\Umrah\UmrahVisa;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahVisaService extends BaseService implements UmrahVisaInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahVisa $model){
        $this->model = $model;
    }

}
