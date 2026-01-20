<?php

namespace App\Http\Controllers\Website;

use App\Http\Controllers\Controller;
use App\Services\Site\ContentPageService;
use App\Services\Visa\CmsVisaPackageService;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Inertia\Inertia;
use Illuminate\Support\Collection;

class VisaController extends Controller
{

    protected $contentPageService;
    protected $cmsVisaPackageService;
    public function __construct(ContentPageService $contentPageService, CmsVisaPackageService $cmsVisaPackageService)
    {
        $this->contentPageService = $contentPageService;
        $this->cmsVisaPackageService = $cmsVisaPackageService;
    }
    
    public function visaListing()
    {
        $visitVisaWithPackages = $this->contentPageService->whereRelation(
            ['status' => 1, 'parentId' => 4],
            ['cmsVisaPackages']
        );
        $manualConsultancyVisas = [
            [
                'packageTitle' => 'UK',
                'urlLink' => 'visa/uk-visit-visa',
                'countryName' => 'uk',
                'type' => 'consultancy',
            ],
            [
                'packageTitle' => 'USA',
                'urlLink' => 'visa/us-visit-visa',
                'countryName' => 'usa',
                'type' => 'consultancy',
            ],
            [
                'packageTitle' => 'Canada',
                'urlLink' => 'visa/canada-visa-consultant-in-islamabad-pakistan',
                'countryName' => 'canada',
                'type' => 'consultancy',
            ],
            [
                'packageTitle' => 'Europe',
                'urlLink' => 'visa/europe-visa',
                'countryName' => 'europe',
                'type' => 'consultancy',
            ],
            [
                'packageTitle' => 'Turkey',
                'urlLink' => 'visa/turkey-visa',
                'countryName' => 'turkey',
                'type' => 'consultancy',
            ],
            [
                'packageTitle' => 'Australia',
                'urlLink' => 'visa/australia-visit-visa',
                'countryName' => 'australia',
                'type' => 'consultancy',
            ],
        ];
        $targetCountries = ['uk', 'usa', 'canada', 'europe', 'turkey', 'australia'];
        $aliases = [
            'us' => 'usa',
            'u.s' => 'usa',
            'u.s.a' => 'usa',
            'united states' => 'usa',
            'england' => 'uk',
            'britain' => 'uk',
        ];
        $otherVisas = [];
        $addedOther = [];
        foreach ($visitVisaWithPackages as $visitVisaWithPackage) {
            $packageTitle = strtolower($visitVisaWithPackage['packageTitle'] ?? '');
            $urlLink = strtolower($visitVisaWithPackage['urlLink'] ?? '');
            $countryName = '';
            if (!empty($visitVisaWithPackage['cmsVisaPackages']) && count($visitVisaWithPackage['cmsVisaPackages']) > 0) {
                $countryName = strtolower(trim($visitVisaWithPackage['cmsVisaPackages'][0]['countryName'] ?? ''));
            }
            if (empty($countryName)) {
                foreach (array_merge($targetCountries, array_keys($aliases)) as $c) {
                    if (preg_match('/\b' . preg_quote($c, '/') . '\b/i', $packageTitle) || preg_match('/\b' . preg_quote($c, '/') . '\b/i', $urlLink)) {
                        $countryName = $c;
                        break;
                    }
                }
            }
            if (isset($aliases[$countryName])) {
                $countryName = $aliases[$countryName];
            }
            if (empty($countryName)) {
                continue;
            }
            $cleanTitle = preg_replace('/\bvisit visa\b/i', '', $visitVisaWithPackage['packageTitle'] ?? '');
            $cleanTitle = ucfirst(trim($cleanTitle));
            $visaData = [
                'packageTitle' => $cleanTitle,
                'urlLink' => $visitVisaWithPackage['urlLink'] ?? '',
                'countryName' => $countryName,
                'type' => 'other',
            ];
            if (in_array($countryName, $targetCountries)) {
                continue;
            }
            if (!in_array($countryName, $addedOther)) {
                $otherVisas[] = $visaData;
                $addedOther[] = $countryName;
            }
        }
        $allVisas = array_merge($manualConsultancyVisas, $otherVisas);
        $headerArr = [
            'title' => 'Visit Visa From Pakistan',
            'metaTitle' => 'Visit Visa From Pakistan',
            'description' => 'Apply easily visit visa! Explore top travel destinations for tourism, family visits, or business trips with quick processing and expert guidance .',
            'og:url' => 'https://www.rehmantravel.com/visa',
            'og:image:secure_url' => 'assets/img/rgt-logo.png',
            'image' => 'assets/img/rgt-logo.png',
            'schemaVal' => '',
        ];
        view()->share('headerArr', $headerArr);
        return Inertia::render('Website/Visa/VisaListing', [
            'visaPackages' => $allVisas,
        ]);
    }

    public function packagesTitle()
    {
        try{
            $urlLink = request()->path();
            $cmsVisas = $this->contentPageService->fetch(['urlLink' => $urlLink, "status" => 1]);
            $collection = new Collection();
            $visasByCountry = $this->sideBar();
            $visaPackages = '';
            $visaDuration = array();
            foreach ($cmsVisas->cmsVisaPackages as $cmsVisaPackage):
                foreach ($cmsVisaPackage->cmsvisaDurations as $cmsvisaDuration):
                    if($cmsvisaDuration['durationStatus'] === 1):
                        $visaDuration[] = array(
                            "id" => $cmsvisaDuration['id'],
                            "visaId" => $cmsvisaDuration['visaId'],
                            "visaTitle" => $cmsvisaDuration['visaTitle'],
                            "visaPrice" => $cmsvisaDuration['visaPrice'],
                            "currency" => $cmsvisaDuration['currency'],
                            "numEntries" => $cmsvisaDuration['numEntries'],
                            "duration" => $cmsvisaDuration['duration'],
                            "validity" => $cmsvisaDuration['validity'],
                            "validForCityId" => $cmsvisaDuration['validForCityId'],
                            "visaType" => $cmsvisaDuration['visaType'],
                            "visaIncludes" => $cmsvisaDuration['visaIncludes'],
                            "durationStatus" => $cmsvisaDuration['durationStatus']
                        );
                    endif;
                endforeach;
                $visaPackages = array(
                    "id" => $cmsVisaPackage['id'],
                    "cmsContentId" => $cmsVisaPackage['cmsContentId'],
                    "countryName" => $cmsVisaPackage['countryName'],
                    "packageUrl" => $cmsVisaPackage['packageUrl'],
                    "tourUrl" => $cmsVisaPackage['tourUrl'],
                );
            endforeach;
            $collection->push((object)[
                'visaDetails' => [
                    "id" => $cmsVisas['id'],
                    "parentId" => $cmsVisas['parentId'],
                    "metaTitle" => $cmsVisas['metaTitle'],
                    "metaDescription" => $cmsVisas['metaDescription'],
                    "canonicalUrl" => $cmsVisas['canonicalUrl'],
                    "urlLink" => $cmsVisas['urlLink'],
                    "packageTitle" => $cmsVisas['packageTitle'],
                    "cardImage" => $cmsVisas['cardImage'],
                    "bannerImage" => $cmsVisas['bannerImage'],
                    "categories" => $cmsVisas['categories'],
                    "price" => $cmsVisas['price'],
                    "sequence" => $cmsVisas['sequence'],
                    "shortDescription" => $cmsVisas['shortDescription'],
                    "includes" => $cmsVisas['includes'],
                    "excludes" => $cmsVisas['excludes'],
                    "documentsRequired" => $cmsVisas['documentsRequired'],
                    "type" => $cmsVisas['type'],
                    "showOnHome" => $cmsVisas['showOnHome'],
                    "description" => $cmsVisas['description'],
                    "status" => $cmsVisas['status']
                ],
                'visaPackages' => $visaPackages,
                'visaDuration' => $visaDuration,
                'visitVisas' => $visasByCountry
            ]);
            if($collection):
                $headerArr = [
                    'title' => $cmsVisas['packageTitle'],
                    'metaTitle' => $cmsVisas['metaTitle'],
                    'description' => $cmsVisas['metaDescription'],
                    'og:url' => 'https://www.rehmantravel.com/'. $cmsVisas['urlLink'],
                    'og:image:secure_url' => 'assets/img/rgt-logo.png',
                    'image' => 'assets/img/rgt-logo.png',
                    'schemaVal' => $cmsVisas['schemaVal'],
                ];
                view()->share('headerArr', $headerArr);
                $isStudy = (strpos(request()->path(), 'study') !== false ? 'study' : 'visa');
                return Inertia::render('Website/Visa/VisaDetailPage', ['visaPackages' => $collection, 'pageType' => $isStudy]);
            else:
               return back()->with(['errorType' => true, 'message' => 'No Data found Against the search']);
            endif;
        }catch(\Exception $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch (\Throwable $ex) {
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }catch(ModelNotFoundException $ex){
            return back()->with(['errorType'=> true,'message'=> $ex->getMessage()]);
        }
    }
    public function sideBar(){
        $visitVisaWithPackages = $this->cmsVisaPackageService->all(['*'],['contentPages']);
        return $visitVisaWithPackages;
    }
}
