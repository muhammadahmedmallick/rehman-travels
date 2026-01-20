<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
class UmrahVehiclePrice extends Model {

    use HasFactory;

    protected $fillable = ['vehicleId','sectorId','vehiclePrice', 'vehicleSectorMarkup', 'vehicleSectorMrkPrice','vehiclePriceStatus', 'transport_markup_id', 'created_by', 'updated_by'];

    private  $__prefix;

    public function __construct(array $attributes = []){}
    public function users(){
        return $this->belongsTo(User::class,'id','postById');
    }

    public function umrahTransportSectors() {
        return $this->hasMany(UmrahTransportSector::class,'id','sectorId');
    }

    public function umrahVehicles() {
        return $this->hasOne(UmrahVehicle::class,'id','vehicleId');
    }
    
    function __destruct() {
        DB::disconnect();
    }


}
