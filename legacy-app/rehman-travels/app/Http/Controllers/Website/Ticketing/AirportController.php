<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ticketing\Sector;

class AirportController extends Controller
{

    public function search(Request $request)
    {
        $search = $request->query('query');
        $results = Sector::select('*')
            ->selectRaw("
            CASE
                WHEN LOWER(code) = LOWER(?) THEN 1
                WHEN LOWER(code) LIKE LOWER(?) THEN 2
                WHEN LOWER(airport) LIKE LOWER(?) THEN 3
                WHEN LOWER(city) LIKE LOWER(?) THEN 4
                WHEN LOWER(country) LIKE LOWER(?) THEN 5
                ELSE 6
            END as relevance
        ", [$search, "%$search%", "%$search%", "%$search%", "%$search%"])
            ->where(function ($query) use ($search) {
                $query->where('code', 'LIKE', "%$search%")
                    ->orWhere('airport', 'LIKE', "%$search%")
                    ->orWhere('city', 'LIKE', "%$search%")
                    ->orWhere('country', 'LIKE', "%$search%");
            })
            ->orderBy('relevance')
            ->limit(10)
            ->get();
        return response()->json($results);
    }


}
