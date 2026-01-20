<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahHotelRoomPeriod extends Model {
    use HasFactory;

    protected $fillable = ["hotelId","periodFrom","periodTo","ashraType","periodStatus"];

    private  $__prefix;

    public function __construct(array $attributes = []){}

    public  function hotelRoomPrices() {
        return $this->hasMany(UmrahHotelRoomPrice::class,'periodId','id');
    }
    function __destruct() {
        DB::disconnect();
    }
}
