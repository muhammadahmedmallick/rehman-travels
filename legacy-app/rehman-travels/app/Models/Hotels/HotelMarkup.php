<?php

namespace App\Models\Hotels;

use App\Models\Umrah\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelMarkup extends Model
{
    use HasFactory;

    protected $fillable = [
        'markup_type',
        'markup_value',
        'markup_status',
        'currency_id',
        'currency_rate',
        'currency_code',
        'converted_value',
        'vendor',
        'created_by',
        'updated_by',
    ];

    public function users(){
        return $this->belongsTo(User::class, 'created_by', 'id');
    }
}
