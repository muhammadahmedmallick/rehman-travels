<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Inertia\Inertia;

class PakistanTourController extends Controller
{
    protected $contentPageService;
    public function __construct(ContentPageService $contentPageService)
    {
        $this->contentPageService = $contentPageService;
    }
    public function packagesTitle()
    {
        try{
            $getUrl = request()->path();
            $pakistanTours = $this->contentPageService->fetchWithRelation('urlLink', $getUrl, ['tourPackages']);
            $pakistanTour = [];
            if(count($pakistanTours->tourPackages) > 0){
                $pakistanTour = array(
                    'metaTitle' => $pakistanTours['metaTitle'],
                    'metaDescription' => $pakistanTours['metaDescription'],
                    'canonicalUrl' => $pakistanTours['canonicalUrl'],
                    'urlLink' => $pakistanTours['urlLink'],
                    'cardImage' => (!empty($pakistanTours['cardImage']) && !is_null($pakistanTours['cardImage']) ? $pakistanTours['cardImage'] : ''),
                    'packageTitle' => $pakistanTours['packageTitle'],
                    'currencyType' => $pakistanTours['currencyType'],
                    'price' => $pakistanTours['price'],
                    'includes' => $pakistanTours['includes'],
                    'excludes' => $pakistanTours['excludes'],
                    'tour_days' => $pakistanTours->tourPackages[0]['tour_days'],
                    'tour_availability' => $pakistanTours->tourPackages[0]['tour_availability'],
                    'price_label' => ($pakistanTours->tourPackages[0]['price_label'] == 0 ? 'Couple' : 'Per Person'),
                    'map' => $pakistanTours->tourPackages[0]['map'],
                    'description' => (!empty($pakistanTours->tourPackages[0]['days_details']) ? $pakistanTours->tourPackages[0]['days_details'] : $pakistanTours['description']),
                    'show_departure' => $pakistanTours->tourPackages[0]['show_departure'],
                    'fixed_date' => $pakistanTours->tourPackages[0]['fixed_date'],
                );
            }else{
                $pakistanTour = array(
                    'metaTitle' => $pakistanTours['metaTitle'],
                    'metaDescription' => $pakistanTours['metaDescription'],
                    'canonicalUrl' => $pakistanTours['canonicalUrl'],
                    'urlLink' => $pakistanTours['urlLink'],
                    'packageTitle' => $pakistanTours['packageTitle'],
                    'currencyType' => $pakistanTours['currencyType'],
                    'price' => $pakistanTours['price'],
                    'cardImage' => (!empty($pakistanTours['cardImage']) && !is_null($pakistanTours['cardImage']) ? $pakistanTours['cardImage'] : ''),
                    'includes' => $pakistanTours['includes'],
                    'excludes' => $pakistanTours['excludes'],
                    'prishortDescriptionce' => $pakistanTours['shortDescription'],
                    'description' => $pakistanTours['description'],
                );;
            }
            if($pakistanTour):
                $headerArr = [
                    'title' => $pakistanTours['packageTitle'],
                    'metaTitle' => $pakistanTours['packageTitle'],
                    'description' => $pakistanTours['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $pakistanTours['urlLink'],
                    'og:image:secure_url' => (!empty($pakistanTours['cardImage']) && !is_null($pakistanTours['cardImage']) ? ('/assets/visa-packages/'. $pakistanTours['cardImage']) : 'assets/img/rgt-logo.png'),
                    'image' => (!empty($pakistanTours['cardImage']) && !is_null($pakistanTours['cardImage']) ? ('/assets/visa-packages/'. $pakistanTours['cardImage']) : 'assets/img/rgt-logo.png'),
                ];
                view()->share('headerArr', $headerArr);
                return Inertia::render('Website/Tours/Pakistan/PakistanTourDetailPage', ['pakistanTour' => $pakistanTour]);
            else:
                return back()->with(['errorType' => true, 'message' => 'Failed! unable to Load Pakistan Tour Page']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function tourListing(){
        $pakistanTourDetails = $this->contentPageService->whereRelation([['parentId', '=', '12'], ['status', '=', '1']], ['tourPackages']);
        $pakistanTour = [];
        foreach($pakistanTourDetails as $pakistanTours):
            if(!empty($pakistanTours->tourPackages) && count($pakistanTours->tourPackages) > 0){
                $pakistanTour[] = array(
                    'canonicalUrl' => $pakistanTours['canonicalUrl'],
                    'urlLink' => $pakistanTours['urlLink'],
                    'packageTitle' => $pakistanTours['packageTitle'],
                    'currencyType' => $pakistanTours['currencyType'],
                    'price' => $pakistanTours['price'],
                    'cardImage' => $pakistanTours['cardImage'],
                    'type' => $pakistanTours['type'],
                    'tour_nights' => $pakistanTours->tourPackages[0]['tour_days'],
                    'tour_days' => ($pakistanTours->tourPackages[0]['tour_days'] ) + 1,
                    'tour_availability' => $pakistanTours->tourPackages[0]['tour_availability'],
                    'price_label' => ($pakistanTours->tourPackages[0]['price_label'] == 0 ? 'Couple' : 'Per Person'),
                    'show_departure' => $pakistanTours->tourPackages[0]['show_departure'],
                    'fixed_date' => $pakistanTours->tourPackages[0]['fixed_date']
                );
            }
        endforeach;
        // dd($pakistanTour);
        $headerArr = [
            'title' => 'Pakistan Tour Packages',
            'metaTitle' => 'Pakistan Tour Packages',
            'description' => 'Explore the charm of Pakistan with our exclusive tour packages. Discover the magnificent northern areas at unbeatable prices with Rehman Travels.',
            'og:url' => 'https://www.rehmantravel.com/pakistantour',
            'og:image:secure_url' => 'assets/img/rgt-logo.png',
            'image' => 'assets/img/rgt-logo.png',
            'schemaVal' => '',
        ];
        view()->share('headerArr', $headerArr);
        return Inertia::render('Website/Tours/Pakistan/PakistanTourListing', ['pakistanTour' => $pakistanTour]);
    }
}