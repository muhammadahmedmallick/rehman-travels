<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UmrahHotel extends Model {

    use HasFactory;

    protected $fillable = ["postById","hotelName","vendorName","hotelLocation","hotelDistance","basisType","hotelType","hotelDesc" ,"markup","hotelStatus", "updated_by"];

    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function hotelUsers(){
        return $this->belongsTo(User::class,'postById','id');
    }

    public function hotelImages() {
        return $this->hasMany(UmrahHotelImage::class,'hotelId','id');
    }
    
    public function hotelRoomPeriods() {
        return $this->hasMany(UmrahHotelRoomPeriod::class,'hotelId','id')->where('umrah_hotel_room_periods.periodStatus', '=', '1');
    }

    public  function hotelRoomPrices() {
        return $this->hasMany(UmrahHotelRoomPrice::class,'periodId',UmrahHotelRoomPeriod::class);
    }

}
