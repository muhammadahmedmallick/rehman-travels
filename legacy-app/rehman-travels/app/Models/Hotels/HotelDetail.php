<?php

namespace App\Models\Hotels;

use App\Models\Profile\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HotelDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'code',
        'address',
        'city',
        'star_rating',
        'vendor',
        'created_by'
    ];

    public function user(){
        return $this->belongsTo(User::class, 'created_by', 'id');
    }
}
