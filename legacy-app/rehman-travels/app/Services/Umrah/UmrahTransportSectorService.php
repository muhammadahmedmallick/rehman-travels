<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahTransportSectorInterface;
use App\Models\Umrah\UmrahTransportSector;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahTransportSectorService extends BaseService implements UmrahTransportSectorInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UserService constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahTransportSector $model){
        $this->model = $model;
    }

}
