<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelBookingRooms extends Model
{
    use HasFactory;

    protected $fillable = [
        'hotel_booking_id',
        'room_key',
        'eqtotal_base_fare',
        'eqtotal_taxes',
        'eqtotal_prices',
        'markup',
        'markup_type',
        'total_base_fare',
        'total_taxes',
        'total_prices',
        'd_currency',
        'd_currency_rate',
        's_currency',
        's_currency_rate',
    ];

    public function roomsGuest(){
        return $this->hasMany(HotelBookingCustomers::class, 'hotel_booking_room_id', 'id');
    }
}
