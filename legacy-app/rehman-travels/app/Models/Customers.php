<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Umrah\UmrahBookingCustomer;
use Illuminate\Support\Facades\DB;
class Customers extends Model
{
    use HasFactory;
    protected $fillable = ["firstName", "mobileNo", "email", "address", "dnd"];
    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function cmsCallbackQueries(){
        return $this->hasMany(CmsCallbackQueries::class, 'customerId', 'id');
    }

    public function Customers(){
        return $this->hasMany(UmrahBookingCustomer::class,'customerId','id');
    }
    
    function __destruct() {
        DB::disconnect();
    }
}
