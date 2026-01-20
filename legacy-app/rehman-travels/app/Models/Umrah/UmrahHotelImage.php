<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahHotelImage extends Model {

    use HasFactory;

    protected $fillable = ["hotelId","hotelImage","hotelRoomType","hotelRoomImageStatus",];

    private  $__prefix;

    public function __construct(array $attributes = []){

    }
    public function umrahHotel(){
        return $this->belongsTo(UmrahHotel::class);
    }
    function __destruct() {
        DB::disconnect();
    }
}
