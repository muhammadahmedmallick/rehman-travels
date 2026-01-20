<?php

namespace App\Models\Queries;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Models\Customers;
use App\Models\Profile\User;

class CmsCallbackQueries extends Model
{
    use HasFactory;
    
    protected $fillable = ["customerId",  "message", "leadFrom", "sectors", "moduleId", "domIntl", "airlineCode", "country", "uuid", "clientIp", "clientBrowser", "clientPlatform", "ismobile", "mobileInfo", "referalUrl"];

    public function customer(){
        return $this->belongsTo(Customers::class, 'customerId', 'id');
    }
    
    public function users(){
        return $this->belongsTo(User::class, 'created_by', 'id');
    }
    
    function __destruct() {
        DB::disconnect();
    }
}
