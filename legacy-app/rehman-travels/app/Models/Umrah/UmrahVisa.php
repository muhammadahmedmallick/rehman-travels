<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahVisa extends Model {
    use HasFactory;

    protected $fillable = ['umrahVisaName','umrahVisaPeriodFrom','umrahVisaPeriodTo','umrahVisaPrice','umrahVisaNationality','umrahVisaPriceStatus'];

    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function user(){
        return $this->belongsTo(User::class,'userId','id');
    }
    function __destruct() {
        DB::disconnect();
    }

}
