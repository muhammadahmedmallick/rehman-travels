<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Customers;
use Illuminate\Support\Facades\DB;
class UmrahBookingCustomer extends Model
{
    use HasFactory;
    protected $fillable = ["customerId","umrahVisaPrice", "umrahSectorId", "umrahVehicleId", "umrahVehiclePrice","nationality","transport","city","adultsCount","childrenCount","infantsCount","totalRoom","totalNight", "totalPrice"];
    private  $__prefix;

    public function __construct(array $attributes = []){}
    
    public function UmrahBookings(){
        return $this->hasMany(UmrahBooking::class, 'bookingCustomerId', 'id');
    }
    public function Customers(){
        return $this->belongsTo(Customers::class,'customerId','id');
    }
    public function Vehicles(){
        return $this->belongsTo(UmrahVehicle::class, 'umrahVehicleId', 'id');
    }
    public function Transport(){
        return $this->belongsTo(UmrahTransportSector::class, 'umrahSectorId', 'id');
    }
    
   function __destruct() {
        DB::disconnect();
    }
}
