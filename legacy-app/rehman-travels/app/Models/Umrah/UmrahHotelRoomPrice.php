<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahHotelRoomPrice extends Model {
    use HasFactory;

    protected $fillable = ["periodId","onDayPrice","onDayMarkup","offDayPrice","offDayMarkup","roomType", "hotel_markup_id"];

    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function hotelRoomPeriods() {
        return $this->belongsTo(UmrahHotelRoomPeriod::class,'periodId','id');
    }
    function __destruct() {
        DB::disconnect();
    }
}
