<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Umrah\UmrahBookingCustomer;
use App\Models\Customers;
use Illuminate\Support\Facades\DB;
class UmrahBooking extends Model
{
    use HasFactory;

    protected $fillable = ["location","bookingCustomerId","hotelId","checkIn","checkOut","doubleRoom","tripleRoom","quadRoom","quintRoom","quintRoom","hotelTotalPrice"];
    private  $__prefix;

    public function __construct(array $attributes = []){}

    public function Customers(){
        return $this->belongsTo(UmrahBookingCustomer::class, 'customerId', Customers::class);
    }
    
    function __destruct() {
        DB::disconnect();
    }
}