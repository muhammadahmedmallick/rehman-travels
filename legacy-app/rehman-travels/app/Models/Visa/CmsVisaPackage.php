<?php

namespace App\Models\Visa;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Site\ContentPage;
use Illuminate\Support\Facades\DB;
class CmsVisaPackage extends Model
{
    use HasFactory;
    
    protected $fillable = ["cmsContentId", "countryName", "packageUrl", "tourUrl"];
    
    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function cmsvisaDurations() {
        return $this->hasMany(CmsVisaDuration::class,'visaId','id');
    }
    
    public function contentPages(){
        return $this->belongsTo(ContentPage::class, 'cmsContentId', 'id');
    }
    function __destruct() {
        DB::disconnect();
    }
}
