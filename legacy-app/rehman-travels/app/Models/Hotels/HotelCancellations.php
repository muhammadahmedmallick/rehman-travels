<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelCancellations extends Model
{
    use HasFactory;

    protected $fillable = [
        'hotel_booking_id',
        'hotel_cancellation_ex_rate',
        'hotel_cancellation_status',
        'hotel_cancellation_currency',
        'created_by',
        'updated_by',
    ];
}
