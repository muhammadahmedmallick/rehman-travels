<?php

namespace App\Models\Hotels;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelConfirmations extends Model
{
    use HasFactory;

    protected $fillable = [
        'confirmation_key',
        'hotel_booking_id',
        'hotel_confirmation_status',
        'booking_creation',
        'supplier_confirmation_number',
        'tass_pro_booking_no',
        'customer_ref_number',
        'registration_number',
        'inv_company_code',
        'inv_company_name',
        'accounts',
        'created_by',
        'updated_by',
    ];
}
