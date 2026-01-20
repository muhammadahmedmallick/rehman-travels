<?php

namespace App\Http\Controllers\Backend\Pages\Site;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Services\Tour\PakistanTourPackageService;
use Image;
use Inertia\Inertia;
use Illuminate\Support\Facades\Auth;

class ContentController extends Controller
{
    protected $contentPageService;
    protected $tourPackageService;
    public function __construct(PakistanTourPackageService $tourPackageService, ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
        $this->tourPackageService = $tourPackageService;
    }
    public function addNewContent(Request $request)
    {
        try
        {
            $a = $request['formData'];
            if (!empty($request->file('formData')) && $request->file('formData')['cardImage']) {
                $cardImage = self::storeImage($request, 'cardImage');
                $a['cardImage'] = $cardImage;
            }
            if (!empty($request->file('formData')) && $request->file('formData')['bannerImage']) {
                $bannerImage = self::storeImage($request, 'bannerImage');
                $a['bannerImage'] = $bannerImage;
            }
            $tourPackages = $request['formData']['tourPackage'];
            $newData =  self::contentData($a);
            $addNewContent = $this->contentPageService->store($newData);
            if(!empty($addNewContent['id']) && !empty($request['formData']['tourCategory']) && $request['formData']['tourCategory'] == "wpackage"):
                $tourDetails = self::tourData($tourPackages, $addNewContent['id']);
                $tourPackage = $this->tourPackageService->store($tourDetails);
            endif;
            
            if ($addNewContent):
                back()->with(['errotType'=> false, 'message' => 'New Content add to the Successfully']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to add New Content']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function updatePageContent(Request $request)
    {
        try
        {
            $a = $request['formData'];
            if (!empty($request['formData']['card'])) {
                $cardImage = self::storeImage($request, 'card');
                $a['cardImage'] = $cardImage;
            }
            if (!empty($request['formData']['banner'])) {
                $bannerImage = self::storeImage($request, 'banner');
                $a['bannerImage'] = $bannerImage;
            }
            $newData =  self::updateContentData($a);
            $updateContent = $this->contentPageService->update($a['id'], $newData);
            if(!empty($a['tourCategory']) == 'wpackage' && !empty($a['tourPackage']) && !empty($a['tourPackage']['id'])):
                $tourDetails = self::tourData($a['tourPackage'], $a['id']);
                $tourPackage = $this->tourPackageService->update($a['tourPackage']['id'], $tourDetails);
            endif;
            if ($updateContent):
                return back()->with(['errotType'=> false, 'message' => 'New Content updated']);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to add New Content']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    private static function contentData($content){
        return array(
            'packageTitle' => (!empty($content['packageTitle']) ? $content['packageTitle'] : ''),
            'parentId' => (!empty($content['parentId']) ? $content['parentId'] : 0),
            'categories' => (!empty($content['categories']) ? $content['categories'] : 0),
            'sequence' => (!empty($content['sequence']) ? $content['sequence'] : 0),
            'departCode' => (isset($content['flight']) && !empty($content['flight']) ? $content['flight']['departCode'] : NULL),
            'arrCode' => (isset($content['flight']) && !empty($content['flight']) ? $content['flight']['arrCode'] : NULL),
            'status' => (!empty($content['status']) ? $content['status'] : 0),
            'urlLink' => (!empty($content['urlLink']) ? $content['urlLink'] : ''),
            'currencyType' => (!empty($content['currencyType']) ? $content['currencyType'] : 'PKR'),
            'bannerImage' => (!empty($content['bannerImage']) ? $content['bannerImage'] : NULL),
            'cardImage' => (!empty($content['cardImage']) ? $content['cardImage'] : NULL),
            'price' => (!empty($content['price']) ? $content['price'] : 0),
            'type' => (!empty($content['type']) ? $content['type'] : 0),
            'showOnHome' => (!empty($content['showOnHome']) ? $content['showOnHome'] : 0),
            'includes' => (!empty($content['includes']) ? $content['includes'] : NULL),
            'excludes' => (!empty($content['excludes']) ? $content['excludes'] : NULL),
            'canonicalUrl' => (!empty($content['canonicalUrl']) ? $content['canonicalUrl'] : ''),
            'metaTitle' => (!empty($content['metaTitle']) ? $content['metaTitle'] : ''),
            'metaDescription' => (!empty($content['metaDescription']) ? $content['metaDescription'] : ''),
            'shortDescription' => (!empty($content['shortDescription']) ? $content['shortDescription'] : NULL),
            'schemaVal' => (!empty($content['schemaVal']) ? $content['schemaVal'] : ''),
            'description' =>(!empty($content['description']) ? $content['description'] : '')
        );
            
    }

    public function tourData($tour, $contentId){
        return array(
            "cms_cp_id" => $contentId,
            "domestic_states_id" => (!empty($tour['domestic_states_id']) ? $tour['domestic_states_id'] : 10),
            "meta_keyword" => (!empty($tour['meta_keyword']) ? $tour['meta_keyword'] : ''),
            "tour_days" => (!empty($tour['tour_days']) ? $tour['tour_days'] : ''),
            "tour_availability" => (!empty($tour['tour_availability']) ? date('Y-m-d', strtotime($tour['tour_availability'])) : '0000-00-00'),
            "price_label" => (!empty($tour['price_label']) ? $tour['price_label'] : 1),
            "discount_price" => (!empty($tour['discount_price']) ? $tour['discount_price'] : '0.00'),
            "departure_location" => (!empty($tour['departure_location']) ? $tour['departure_location'] : ''),
            "destination_location" => (!empty($tour['destination_location']) ? $tour['destination_location'] : ''),
            "tour_services" => (!empty($tour['tour_services']) ? $tour['tour_services'] : ''),
            "map" => (!empty($tour['map']) ? $tour['map'] : ''),
            "days_details" => (!empty($tour['days_details']) ? $tour['days_details'] : ''),
            "show_departure" => (!empty($tour['show_departure']) ? $tour['show_departure'] : 0),
            "fixed_date" => (!empty($tour['fixed_date']) ? $tour['fixed_date'] : ''),
            "tour_status" => (!empty($tour['tour_status']) ? $tour['tour_status'] : 0),
            "created_by" => (empty($tour['id']) ? Auth::user()->id : $tour['created_by']),
            "updated_by" => (!empty($tour['id']) ? Auth::user()->id : NULL)
        );
    }
    
    private static function updateContentData($content){
        return array(
            'packageTitle' => (!empty($content['packageTitle']) ? $content['packageTitle'] : ''),
            'parentId' => (!empty($content['parentId']) ? $content['parentId'] : 0),
            'categories' => (!empty($content['categories']) ? $content['categories'] : 0),
            'sequence' => (!empty($content['sequence']) ? $content['sequence'] : 0),
            'departCode' => (isset($content['departCode']) && !empty($content['departCode']) ? $content['departCode'] : NULL),
            'arrCode' => (isset($content['arrCode']) && !empty($content['arrCode']) ? $content['arrCode'] : NULL),
            'status' => (!empty($content['status']) ? $content['status'] : 0),
            'urlLink' => (!empty($content['urlLink']) ? $content['urlLink'] : ''),
            'currencyType' => (!empty($content['currencyType']) ? $content['currencyType'] : 'PKR'),
            'bannerImage' => (!empty($content['bannerImage']) ? $content['bannerImage'] : NULL),
            'cardImage' => (!empty($content['cardImage']) ? $content['cardImage'] : NULL),
            'price' => (!empty($content['price']) ? $content['price'] : 0),
            'type' => (!empty($content['type']) ? $content['type'] : 0),
            'showOnHome' => (!empty($content['showOnHome']) ? $content['showOnHome'] : 0),
            'includes' => (!empty($content['includes']) ? $content['includes'] : NULL),
            'excludes' => (!empty($content['excludes']) ? $content['excludes'] : NULL),
            'canonicalUrl' => (!empty($content['canonicalUrl']) ? $content['canonicalUrl'] : ''),
            'metaTitle' => (!empty($content['metaTitle']) ? $content['metaTitle'] : ''),
            'metaDescription' => (!empty($content['metaDescription']) ? $content['metaDescription'] : ''),
            'shortDescription' => (!empty($content['shortDescription']) ? $content['shortDescription'] : NULL),
            'schemaVal' => (!empty($content['schemaVal']) ? $content['schemaVal'] : ''),
            'description' =>(!empty($content['description']) ? $content['description'] : '')
        );
            
    }
    
    public function deletePageContent($id){
        try{
            if(!empty($id)){
               $destoryPageContent =  $this->contentPageService->delete($id);
            }else{
                return back()->with(['errorType'=> false, 'message' => 'data is not removed successfully.']);
            }
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function storeImage($req, $type){
        $imageName = $req->file('formData')[$type]->getClientOriginalName();
        $file = $req->file('formData')[$type];
        $file->move('assets/'.(!empty($content['parentId']) && $content['parentId'] == '21' ? 'Immigration' : $req['formData']['categories'] ), $imageName);
        return $imageName;
    }
}
