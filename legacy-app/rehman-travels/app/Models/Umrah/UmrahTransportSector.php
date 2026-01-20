<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahTransportSector extends Model {
    use HasFactory;

    protected $fillable = ["sectorName", "sectorMarkup", "sectorStatus"];

    private  $__prefix;

    public function __construct(array $attributes = []){

    }
    public function user(){
        return $this->belongsTo(User::class,'userId','id');
    }
    function __destruct() {
        DB::disconnect();
    }
}

