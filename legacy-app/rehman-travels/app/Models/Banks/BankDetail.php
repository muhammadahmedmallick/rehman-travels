<?php

namespace App\Models\Banks;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class BankDetail extends Model
{
    use HasFactory;
    protected $fillable = ["bankName","accountTitle","branchCode","accountNo","ibanNo","swiftCode","contactNo","bankStatus", "bankLogoName"];
    private  $__prefix;
    
    public function __construct(array $attributes = []){}
     
     public static function banks(){
        return self::where('bankStatus','1')->get(['bankName','accountTitle','branchCode','accountNo','ibanNo','swiftCode','contactNo']);
    }
    
    function __destruct() {
        DB::disconnect();
    }    
}
