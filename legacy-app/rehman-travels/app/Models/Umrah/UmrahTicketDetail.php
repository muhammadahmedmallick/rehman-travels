<?php

namespace App\Models\Umrah;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UmrahTicketDetail extends Model
{
    use HasFactory;
    
    protected $fillable = ["adultPrice","childPrice","infantPrice","bookingCustomerId","selectedCurrency","sector","departure","arrival" ,"created_by","updated_by"];
    private  $__prefix;

    
    public function UmrahTicketFare(){
        return $this->belongsTo(UmrahBookingCustomer::class, 'id', 'bookingCustomerId');
    }
}
