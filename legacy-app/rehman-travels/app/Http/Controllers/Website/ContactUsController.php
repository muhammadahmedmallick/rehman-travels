<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Services\Branches\BranchService;
use Illuminate\Database\Eloquent\ModelNotFoundException;


class ContactUsController extends Controller
{
    protected $branchService;

    public function __construct(BranchService $branchService){
        $this->branchService = $branchService;
    }
    public function index()
    {
        try{
            $branches = $this->branchService->whereQuery(['branchStatus' => 'active', 'branch_Type' => '1']);
            if($branches):
                $headerArr = [
                    'title' => 'Contact Us - Rehman Travel',
                    'metaTitle' => 'Contact Us - Rehman Travel',
                    'description' => 'Contact Us - Rehman Travel - We Will Reach in A While.',
                    'og:url' => 'https://www.rehmantravel.com/contactUs',
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => '',
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/ContactUs/ContactUsPage',['branches' => $branches]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Branches']);
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
