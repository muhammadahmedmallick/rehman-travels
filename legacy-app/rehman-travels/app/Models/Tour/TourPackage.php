<?php

namespace App\Models\Tour;

use App\Models\Site\ContentPage;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TourPackage extends Model
{
    use HasFactory;

    protected $fillable = ["cms_cp_id", "tour_status", "domestic_states_id", "meta_keyword", "tour_days", "tour_availability", "price_label", "discount_price",
     "departure_location","destination_location", "tour_services","map", "days_details", "show_departure", "fixed_date"];

    public function tourPackages(){
        return $this->hasOne(ContentPage::class, 'id', 'cms_cp_id');
    }
}