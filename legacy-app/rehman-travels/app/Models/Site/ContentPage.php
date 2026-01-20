<?php

namespace App\Models\Site;

use App\Models\Tour\TourPackage;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Visa\CmsVisaPackage;
use Illuminate\Support\Facades\DB;

class ContentPage extends Model
{
    use HasFactory;

    protected $fillable = ["parentId", "metaTitle", "metaDescription", "bannerImage", "cardImage", "departCode",  "arrCode", "type", "showOnHome", "canonicalUrl", "urlLink", "categories", "includes", "excludes", "packageTitle", "currencyType", "price", "sequence", "description", "shortDescription", "schemaVal", "status"];

    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function parentPages(){
       return $this->belongsTo(ParentPage::class, 'parentId', 'id');
    }

    public function parents(){
        return $this->belongsTo(ParentPage::class, 'parentId', 'id');
     }

    public  function cmsVisaPackages() {
        return $this->hasMany(CmsVisaPackage::class,'cmsContentId','id');
    }
    
    public function tourPackages(){
        return $this->hasMany(TourPackage::class, 'cms_cp_id', 'id');
    }
    
    public function users(){
        return $this->hasMany(User::class, 'created_by', 'id');
    }
    
    function __destruct() {
        DB::disconnect();
    }


}
