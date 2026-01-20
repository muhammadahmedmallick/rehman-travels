<?php

namespace App\Services\Umrah;

use App\Interfaces\Umrah\UmrahTicketDetailsInterface;
use App\Models\Umrah\UmrahTicketDetail;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Model;


class UmrahTicketDetailsService extends BaseService implements UmrahTicketDetailsInterface {
    /**
    * @var Model
     */
    protected $model;

    /**
     * UmrahTicketDetail constructor.
     *
     * @param Model $model
     */

    public function __construct(UmrahTicketDetail $model){
        $this->model = $model;
    }

}
