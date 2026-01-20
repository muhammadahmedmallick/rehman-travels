<?php

namespace App\Models\Queries;

use App\Models\Customers;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StudyabroadCallbackQuery extends Model
{
    use HasFactory;

    protected $fillable = [
        "customerId",
        "city",
        "degree",
        "gradutaionYear",
        "grade",
        "isIelts",
        "income",
        "accBalance",
        "university",
        "interest",
        "leadFrom",
        "clientIp",
        "message"
    ];

    public function customers(){
        return $this->belongsTo(Customers::class, 'customerId', 'id');
    }
}