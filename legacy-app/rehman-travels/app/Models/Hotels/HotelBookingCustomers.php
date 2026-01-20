<?php

namespace App\Models\Hotels;

use App\Models\Customers;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelBookingCustomers extends Model
{
    use HasFactory;

    protected $fillable = [
        'hotel_booking_room_id',
        'hotel_customer_id',
        'title',
        'firstName',
        'lastName',
        'age',
        'isLeadPax',
    ];

    public function roomsGuest(){
        return $this->belongsTo(HotelBookingRooms::class,'hotel_booking_room_id','id');
    }

    public function customers(){
        return $this->belongsTo(Customers::class, 'hotel_customer_id', 'id');
    }
}
