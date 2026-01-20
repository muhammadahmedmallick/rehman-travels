<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahVehicle extends Model {
    use HasFactory;

    protected $fillable = ['*'];

    private  $__prefix;

    public function __construct(array $attributes = []){

    }
    function __destruct() {
        DB::disconnect();
    }
}
