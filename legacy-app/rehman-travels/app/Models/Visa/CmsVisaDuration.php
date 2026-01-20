<?php

namespace App\Models\Visa;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class CmsVisaDuration extends Model
{
    use HasFactory;
        
    protected $fillable = ["visaId", "visaTitle", "visaPrice", "currency","numEntries", "duration", "validity", "validForCityId","visaType","visaIncludes","durationStatus"];
    
    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function cmsVisaPackages() {
        return $this->belongsTo(CmsVisaPackage::class,'visaId','id');
    }
    function __destruct() {
        DB::disconnect();
    }
}
