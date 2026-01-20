<?php

namespace App\Http\Controllers\Backend\ArabianOryx;

use App\Http\Controllers\Controller;
use App\Services\Hotels\HotelDetailServices;
use Illuminate\Http\Request;
use Inertia\Inertia;

use function Termwind\render;

class ManageHotelController extends Controller
{
    protected $hotelDetailServices;

    public function __construct(HotelDetailServices $hotelDetailServices)
    {
        $this->hotelDetailServices = $hotelDetailServices;
    }

    public function index(){
        $hotelDetails = $this->hotelDetailServices->all(['*'], ['user']);
        $hotels = [];
        foreach($hotelDetails as $hotelDetail){
            $hotels[] = [
                'id' => $hotelDetail->id,
                'name' => $hotelDetail->name,
                'star_rating' => $hotelDetail->star_rating,
                'code' => $hotelDetail->code,
                'address' => $hotelDetail->address,
                'city' => $hotelDetail->city,
                'vendor' => $hotelDetail->vendor,
                'created_by' => (isset($hotelDetail['user']) ? $hotelDetail['user']['userName'] : 'Website'),
                'created_at' => date('H:s d-m-Y', strtotime($hotelDetail->created_at)),
            ];
        }
        return Inertia::render('Backend/ArabianOryx/ManageHotels', ['hotels' => $hotels]);
    }
}
