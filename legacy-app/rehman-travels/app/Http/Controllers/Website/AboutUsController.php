<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Banks\BankDetailServices;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class AboutUsController extends Controller
{
    protected $bankDetailServices;
    public function __construct(BankDetailServices $bankDetailServices){
        $this->bankDetailServices = $bankDetailServices;
    }
    public function index(){
        try
        {
            $headerArr = [
                'title' => 'Company Profile - Rehman Travel',
                'metaTitle' => 'Company Profile - Rehman Travel',
                'description' => 'Company Profile - Rehman Travel - We Will Reach in A While.',
                'og:url' => 'https://www.rehmantravel.com/aboutUs',
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
                'schemaVal' => '',
            ];
            view()->share('headerArr', $headerArr);
            return Inertia::render('Website/AboutUs/CompanyProfile');
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function bankDetails(){
        try
        {
            $bankDetails = $this->bankDetailServices->where('bankStatus', '1');
            $headerArr = [
                'title' => 'Bank and Branch Details - Rehman Travel',
                'metaTitle' => 'Bank and Branch Details - Rehman Travel',
                'description' => 'Bank and Branch Details - Rehman Travels.',
                'og:url' => 'rehmantravel.com/bank-details',
                'og:image:secure_url' => 'assets/img/rgt-logo.png',
                'image' => 'assets/img/rgt-logo.png',
                'schemaVal' => '',
            ];
            view()->share('headerArr', $headerArr);
            if($bankDetails):
                return Inertia::render('Website/AboutUs/BankAccounts/BanksAccounts', ['bankDetails' => $bankDetails]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! to load RGT Banks.']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
}
