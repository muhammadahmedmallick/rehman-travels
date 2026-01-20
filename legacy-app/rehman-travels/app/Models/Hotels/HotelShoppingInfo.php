<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelShoppingInfo extends Model
{
    use HasFactory;

    protected $fillable = [
        'country_code',
        'destination_code',
        'group_code',
        'hotel_detail_id',
    ];

    public function hotelbookings(){
        return $this->hasMany(HotelBookings::class, 'hotel_shopping_info_id', 'id');
    }

    public function hotelDetails(){
        return $this->belongsTo(HotelDetail::class, 'hotel_detail_id', 'id');
    }

    public function hotelRoomDetails()
    {
        return $this->hasManyThrough(
            HotelRoomDetail::class,
            HotelBookings::class,
            'hotel_shopping_info_id',
            'hotel_booking_id',
            'id',
            'id'
        );
    }
}
