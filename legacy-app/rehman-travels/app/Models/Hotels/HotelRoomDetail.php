<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelRoomDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'hotel_booking_id',
        'room_name',
        'meal',
        'rate_type',
        'rate_key',
        'status',
        'marriage_identifier',
        'reprice',
        'is_price_breakup_available',
        'is_cancelation_policy_availble',
    ];
}
