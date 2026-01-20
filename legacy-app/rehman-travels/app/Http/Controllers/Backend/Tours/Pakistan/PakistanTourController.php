<?php

namespace App\Http\Controllers\Backend\Tours\Pakistan;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Services\Site\ContentPageService;
use App\Services\Site\ParentPageService;
use Inertia\Inertia;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Collection;

class PakistanTourController extends Controller
{
    protected $parentPageService;
    protected $contentPageService;
    public function __construct(ParentPageService $parentPageService, ContentPageService $contentPageService)
    {
        $this->parentPageService = $parentPageService;
        $this->contentPageService = $contentPageService;
    }
    public function index(Request $request){
        try{
            $pakistanTourDetails = new Collection();
            $pakistanTours = $this->contentPageService->whereWithRelation('parentId',12,['parentPages', 'tourPackages']);
            $parentPages = $this->parentPageService->all(['id', 'title']);
            foreach($pakistanTours as $pakistanTour):
                if(!empty($pakistanTour['tourPackages'])):
                    $tourPackages = array();
                    foreach($pakistanTour['tourPackages'] as $tourPackage):
                        $tourPackages = [
                            'id' => $tourPackage['id'],
                            'cms_cp_id' => $pakistanTour['id'],
                            'meta_keyword' => $tourPackage['meta_keyword'],
                            'tour_days' => $tourPackage['tour_days'],
                            'tour_availability' => $tourPackage['tour_availability'],
                            'price_label' => $tourPackage['price_label'],
                            'discount_price' => $tourPackage['discount_price'],
                            'departure_location' => $tourPackage['departure_location'],
                            'destination_location' => $tourPackage['destination_location'],
                            'tour_services' => $tourPackage['tour_services'],
                            'map' => $tourPackage['map'],
                            'days_details' => $tourPackage['days_details'],
                            'show_departure' => $tourPackage['show_departure'],
                            'fixed_date' => $tourPackage['fixed_date'],
                            'tour_status' => $tourPackage['tour_status'],
                            'created_by' => $tourPackage['created_by']
                        ];
                    endforeach;
                endif;
                $pakistanTourDetails->push((object)[
                    'pakistanTours'=>[
                        'id' => $pakistanTour['id'],
                        'packageTitle' => $pakistanTour['packageTitle'],
                        'parentId' => $pakistanTour['parentId'],
                        'parent_pages' => $pakistanTour['parentPages']['title'],
                        'sequence' => $pakistanTour['sequence'],
                        'status' => $pakistanTour['status'],
                        'urlLink' => $pakistanTour['urlLink'],
                        'currencyType' => $pakistanTour['currencyType'],
                        'bannerImage' => $pakistanTour['bannerImage'],
                        'cardImage' => $pakistanTour['cardImage'],
                        'categories' => $pakistanTour['categories'],
                        'price' => $pakistanTour['price'],
                        'type' => $pakistanTour['type'],
                        'showOnHome' => $pakistanTour['showOnHome'],
                        'includes' => $pakistanTour['includes'],
                        'excludes' => $pakistanTour['excludes'],
                        'canonicalUrl' => $pakistanTour['canonicalUrl'],
                        'metaTitle' => $pakistanTour['metaTitle'],
                        'metaDescription' => $pakistanTour['metaDescription'],
                        'shortDescription' => $pakistanTour['shortDescription'],
                        'description' => $pakistanTour['description'],
                        'created_at' => date('h:i A | d-m-Y', strtotime($pakistanTour['created_at'])),
                        '_method' => 'POST',
                    ],
                    'tourPackages' => $tourPackages,
                ]);
            endforeach;
            if($pakistanTourDetails):
                return Inertia::render('Backend/Tours/Pakistan/AllPakistanTourDetails', ['pakistanTourDetails' => $pakistanTourDetails, 'parentPages' => $parentPages]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to get Pakistan Tours From DataBase.']);
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
