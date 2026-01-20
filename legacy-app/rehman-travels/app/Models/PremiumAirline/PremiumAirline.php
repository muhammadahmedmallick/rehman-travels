<?php

namespace App\Models\PremiumAirline;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;

class PremiumAirline extends Model
{

    use HasFactory;

    public static function airlines()
    {
        try {
            return self::where(["airlineType" => 'supplier','agentId' => 1182])->first('title');
        } catch (\Exception $e) {
            return "";
        }
    }


}
