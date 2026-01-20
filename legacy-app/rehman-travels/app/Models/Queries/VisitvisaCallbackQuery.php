<?php

namespace App\Models\Queries;

use App\Models\Customers;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VisitvisaCallbackQuery extends Model
{
    use HasFactory;

    protected $fillable = [
        "customerId",
        "dob",
        "passportValidity",
        "incomeSource",
        "incomeType",
        "incomeAmount",
        "taxFiler",
        "taxReturns",
        "bankStatement",
        "sufficientFunds",
        "maritalStatus",
        "interest",
        "kids",
        "member",
        "education",
        "purpose",
        "travelHistory",
        "travelledCountries",
        "leadFrom",
        "clientIp",
    ];

    public function customers(){
        return $this->belongsTo(Customers::class, 'customerId', 'id');
    }
}
