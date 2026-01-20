<?php

namespace App\Models\Currency;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class Currency extends Model {

    use HasFactory;

    function __destruct() {
        DB::disconnect();
    }
    
}
