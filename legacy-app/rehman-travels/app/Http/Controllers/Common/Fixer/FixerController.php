<?php

namespace App\Http\Controllers\Common\Fixer;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Libraries\fixer\FixerClientProvider;
use App\Models\Currency\Currency;
class FixerController extends Controller
{

    private $fixerClientProvider;

    public function __construct(FixerClientProvider $fixerClientProvider)
    {
        $this->fixerClientProvider = $fixerClientProvider;
    }

    public function retrieve(Request $request)
    {
        try{
            foreach(Currency::whereNotIn('currencyCode',['PKR','DEF'])->get() as $currency):
                $fixerClientProvider = $this->fixerClientProvider->retrieve($currency->currencyCode);
                $currencyProvider = Currency::find($currency->id);
                $currencyProvider->currencyRate = $fixerClientProvider['rates']['PKR'];
                $currencyProvider->save();
            endforeach;
        }catch(\Exception $ex){
            dd($ex);
        }
    }

}
