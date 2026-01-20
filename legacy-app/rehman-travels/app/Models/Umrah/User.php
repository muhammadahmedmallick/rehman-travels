<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class User extends Model {

    use HasFactory;

    protected $fillable = ['*'];
    
    function __destruct() {
        DB::disconnect();
    }

}
