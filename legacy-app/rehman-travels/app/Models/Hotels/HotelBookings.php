<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelBookings extends Model
{
    use HasFactory;

    protected $fillable = [
        'hotel_shopping_info_id',
        'hotel_session_id',
        'check_in',
        'check_out',
        't_nights',
        't_rooms',
        't_adults',
        't_childs',
        'nationality',
    ];

    public function hotelBookingRooms(){
        return $this->hasMany(HotelBookingRooms::class, 'hotel_booking_id', 'id');
    }

    public function roomsGuest() {
        return $this->hasMany(HotelBookingCustomers::class,'hotel_booking_room_id', HotelBookingRooms::class);
    }

    public function ShoppingInfo()
    {
        return $this->belongsTo(HotelShoppingInfo::class, 'hotel_shopping_info_id', 'id');
    }
    
    public function hotelRoomDetails(){
        return $this->belongsTo(HotelRoomDetail::class, 'id', 'hotel_booking_id');
    }
}
