<?php
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use App\Mail\MyTestEmail;
use Illuminate\Support\Facades\Mail;
use App\Mail\FiredNotifyMail;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Route::get('/', 'Website\HomeController@index')->name('home');
Route::get('/get-all-parent', 'Backend\Pages\Site\ParentController@index')->name('content.parentPage');
Route::get('sitemap.xml', 'Website\HomeController@sitemap')->name('home');
Route::group(['prefix' => 'ticketing'],function(){
    Route::get('/cheapest-fare-airports', 'Website\Ticketing\AirportController@search')->name('search');
    Route::post('/calendar-fare-request', 'Website\Ticketing\CheapestCalendarFareController@calendarFareRequest')->name('calendarFareRequest');
    Route::get('/cheapest-fare-flight', 'Website\Ticketing\FlightSearchController@cheapestFareFlight')->name('cheapestFareFlight');
    Route::get('/cheapest-fare-flight', 'Website\Ticketing\FlightSearchController@cheapestFareFlight')->name('cheapestFareFlight');
    Route::post('/cheapest-fare-airshopping-request', 'Website\Ticketing\CheapestFareAirShoppingController@cheapestFareAirshoppingRequest')->name('cheapestFareAirshoppingRequest');
    Route::post('/cheapest-fare-flight-fare-rule-request', 'Website\Ticketing\CheapestFareFlightFareRuleController@cheapestFareFlightFareRuleRequest')->name('cheapestFareFlightFareRuleRequest');
    Route::get('/cheapest-fare-flight-order-create', 'Website\Ticketing\OrderCreateController@cheapestFareFlightOrderCreate')->name('cheapestFareFlightOrderCreate');
    Route::post('/cheapest-fare-flight-order-create-request', 'Website\Ticketing\CheapestFareFlightOrderCreateController@cheapestFareFlightOrderCreateRequest')->name('cheapestFareFlightOrderCreateRequest');
    // Route::get('/cheapest-fare-stripe-pay-success-response', 'Common\Stripepay\StripepayController@stripepaySuccessResponse')->name('stripepaySuccessResponse');
    // Route::get('/cheapest-fare-stripe-pay-fail-response', 'Common\Stripepay\StripepayController@stripepayFailResponse')->name('stripepayFailResponse');
    Route::get('/cheapest-fare-flight-order-retrieve', 'Website\Ticketing\CheapestFareFlightOrderRetrieveController@CheapestFareFlightOrderRetrieve')->name('CheapestFareFlightOrderRetrieve');
    Route::get('/cheapest-fare-flight-error', 'Website\Ticketing\CheapestFareFlightErrorController@index')->name('index');
    Route::post('/cheapest-fare-flight-order-retrieve-send-pdf-email', 'Website\Ticketing\CheapestFareFlightOrderRetrieveEmailController@cheapestFareFlightOrderRetrieveSendPdf')->name('cheapestFareFlightOrderRetrieveSendPdf');
    Route::post('/cheapest-fare-flight-fare-rule-send-pdf-email', 'Website\Ticketing\CheapestFareFlightFareRuleEmailController@cheapestFareFlightFareRuleSendPdf')->name('cheapestFareFlightFareRuleSendPdf');
    // Route::get('/cheapest-fare-alfalah-pay-success-response', 'Common\Stripepay\StripepayController@stripepaySuccessResponse')->name('stripepaySuccessResponse');
    // Route::get('/cheapest-fare-alfalah-pay-fail-response', 'Common\Stripepay\StripepayController@stripepayFailResponse')->name('stripepayFailResponse');
});
Route::group(['prefix' => 'flights'], function(){
    Route::get('/', 'Website\FlightController@index')->name('flights');
    Route::get('{pageTitle}', 'Website\FlightController@flightDetails')->name('flightDetails');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix' => 'airlines'], function(){
    Route::get('{pageTitle}', 'Website\FlightController@flightDetails')->name('airlinestDetails');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix' => '/routes'], function(){
    Route::get('/{dept}/{arr}/{deptarr}', 'Website\Ticketing\FlightSearchController@dynamicSearchFlight')->name('routes.dynamicPages');
});
Route::group(['prefix' => 'domestic-flights'], function(){
    Route::get('{packagesTitle}', 'Website\DomesticFlightsController@index')->name('domesticflights');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addDomesticflights');
});
Route::group(['prefix' => 'payonline'],function(){
    Route::get('/cheapest-fare-order-pay-now', 'Common\Payment\CheapestFareOrderPaymentNowController@index')->name('index');
    Route::post('/cheapest-fare-order-alfalah-pay-online-request', 'Common\Alfalah\AlfalahpayController@alfalahPay')->name('alfalahPay');
    Route::get('/cheapest-fare-alfalah-pay-success-response', 'Common\Alfalah\AlfalahpayController@alfalahPaySuccessResponse')->name('alfalahPaySuccessResponse');
    // Route::get('/cheapest-fare-alfalah-pay-success-response-test', 'Common\Alfalah\AlfalahpayController@alfalahPaySuccessResponseTest')->name('alfalahPaySuccessResponseTest');
    Route::post('/cheapest-fare-order-alfalah-pay-online-initiatehc-request', 'Common\Alfalah\AlfalahpayController@initiateHc')->name('initiateHc');
    Route::match(['get','post'],'/cheapest-fare-order-alfalah-pay-online-processhc-request', 'Common\Alfalah\AlfalahpayController@processHc')->name('processHc');
});
Route::group(['prefix' => 'cash'],function(){
    Route::post('/cheapest-fare-order-pay-cash-request', 'Common\Cash\CheapestFareFlightOrderPayCashController@cheapestFareFlightOrderPayCash')->name('cheapestFareFlightOrderPayCash');
});
Route::group(['prefix' => 'viaonline'],function(){
    Route::post('/cheapest-fare-order-pay-via-online-bank-request', 'Common\Cash\CheapestFareFlightOrderPayCashController@cheapestFareFlightOrderPayCash')->name('cheapestFareFlightOrderPayCash');
});
Route::group(['prefix' => 'fixer'], function(){
    Route::get('/cheapest-fare-fixer-response', 'Common\Fixer\FixerController@retrieve')->name('retrieve');
});
Route::group(['prefix' => 'umrah-packages'], function($packagesTitle){
    Route::get('{packagesTitle}', 'Website\UmrahController@packagesTitle')->name('umrahSinglePackage');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix'=>'Umrhbookingdyn'], function(){
    Route::get('sendEmail', 'Website\UmrahController@sendEmail')->name('sendEmail');
    Route::match(['get', 'post'],'/', 'Website\UmrahController@packagesTitle')->name('umrahSinglePackage');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
    Route::match(['get','post'],'/hoteldetails', 'Website\UmrahController@hotelById')->name('hotelById');
});
Route::group(['prefix' => 'hotels'], function(){
    Route::get('{pageTitle}', 'Website\HotelController@hotelDetails')->name('hotelDetails');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix' => 'visa'], function(){
    Route::get('{packagesTitle}', 'Website\VisaController@packagesTitle')->name('visaSignlePackage');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
    Route::post('add-study-details', 'Website\StudyVisaController@index')->name('visa-study.index');
    Route::post('add-visa-details', 'Website\VisitVisaController@index')->name('visa-study.index');
});
Route::group(['prefix' => 'world-tours'], function(){
    Route::get('{packagesTitle}', 'Website\WorldTourController@packagesTitle')->name('worldTourSignlePackage');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});

Route::group(['prefix' => 'immigration'], function(){
    Route::get('/', 'Website\StudyImmigrationController@immigrationListing')->name('immigrationListing');
    Route::get('{packagesTitle}', 'Website\StudyImmigrationController@packagesTitle')->name('immigrations');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix' => 'study'], function(){
    Route::get('/', 'Website\StudyImmigrationController@immigrationListing')->name('immigrationListing');
    Route::get('{packagesTitle}', 'Website\StudyImmigrationController@packagesTitle')->name('immigrations');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});

Route::group(['prefix' => 'pakistantours'], function(){
    Route::get('/', 'Website\PakistanTourController@tourListing')->name('pakistanTourListing');
    Route::get('{packagesTitle}/{packagesTitles?}', 'Website\PakistanTourController@packagesTitle')->name('pakistanTourSignlePackage');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix' => 'hajj'], function(){
    Route::get('{packagesTitle}', 'Website\HajjPackageController@packagesTitle')->name('hajjPackages');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::post('/addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
Route::get('aboutUs', 'Website\AboutUsController@index')->name('aboutUs');
Route::get('bank-details', 'Website\AboutUsController@bankDetails')->name('bankDetails');
Route::group(["prefix" => 'franchise'], function(){
    Route::get('/', 'Website\FranchiseController@index')->name('franchise.index');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails')->name('franchise.addQuery');
});
Route::group(["prefix" => 'franchise-reg'], function(){
    Route::get('/', 'Website\FranchiseController@index')->name('franchise.index');
    Route::get('/{packagesTitle}', 'Website\FranchiseController@index')->name('franchise.packagesTitle');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(["prefix" => 'travel-agency'], function(){
    Route::get('{packagesTitle}', 'Website\TravelAgencyController@index')->name('travelAgencyContent');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});

Route::group(['prefix' => 'hotel'], function () {
    Route::get('/home-page', 'Website\ArabianOryx\ArabianOryxShoppingController@homePage')->name('hotel.homePage');
    Route::get('/', 'Website\ArabianOryx\ArabianOryxShoppingController@index')->name('hotel.index');
    Route::post('/shopping', 'Website\ArabianOryx\ArabianOryxShoppingController@arabianOryxShopping')->name('hotel.arabianOryxShopping');
    Route::match(['get','post'],'/shopping-details', 'Website\ArabianOryx\ArabianOryxShoppingRoomController@arabianOryxShoppingRooms')->name('hotel.arabianOryxShoppingRooms');
    Route::match(['get','post'],'/shopping-details-retrieve', 'Website\ArabianOryx\ArabianOryxShoppingAvailibilityBookingController@arabianOryxShoppingAvailibility')->name('hotel.arabianOryxShoppingAvailibility');
    Route::match(['get','post'],'/shopping-order-create', 'Website\ArabianOryx\ArabianOryxShoppingOrderCreateController@arabianOryxOrderCreate')->name('hotel.arabianOryxShoppingAvailibility');
    Route::match(['get','post'],'/shopping-confirmation', 'Website\ArabianOryx\ArabianOryxShoppingConfirmationController@index')->name('hotel.arabianOryxShoppingConfirmationIndex');
    Route::post('/hotel-cancellation-policy', 'Website\ArabianOryx\HotelCancellationPolicyController@arabianOryxCancellationPolicy')->name('hotel.cancellationPolicy');
    Route::post('/hotel-price-breakup', 'Website\ArabianOryx\HotelPriceBreakupController@arabianOryxPriceBreakup')->name('hotel.pricebreakup');
});
Route::get('/privacy', function(){
    return Inertia::render('Website/Common/PrivacyPolicy');
});
Route::get('/refund-policy', function(){
    return Inertia::render('Website/Common/RefundPolicy');
});
Route::get('/terms-and-conditions', function(){
    return Inertia::render('Website/Common/TermsandConditions');
});
Route::group(['prefix' => 'contactUs'], function(){
    Route::get('/', 'Website\ContactUsController@index')->name('contactUs');
    Route::post('addContactDetails', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('addContactDetails');
});
Route::group(['prefix'=>'subscribe'], function(){
    Route::post('/addSubscribe', 'Website\Subscribe\SubscribeController@store')->name('subscribe.store');
});
Route::get('/Website/thankYou', 'Backend\Queries\CallBackQueryController@thankYou')->name('welcome.thankyou');
Route::post('whatsapp', 'Website\HomeController@whatsappLead')->name('whatsappLead');
Route::fallback(function () {
    return redirect('/');
});
Route::group(['middleware' => ['auth:agent,user']], function () {
    Route::get('/dashboard', function () {
        return Inertia::render('Backend/Home/Index');
    })->name('dashboard');
    Route::post('/lead-whatsapp', 'Website\HomeController@reportwhatsappLead')->name('whatsappLead');
    Route::get('/dashboard/flights', 'Backend\Pages\Airline\FlightPageController@index')->name('flights.index');
    Route::group(['prefix' => '/b2b/permission'], function () {
        Route::get('/view-all-permission', 'Backend\Permission\PermissionController@index')->name('index');
        Route::post('/find-all-permission-request', 'Backend\Permission\PermissionController@findAll')->name('findAll');
        Route::post('/create-new-permission-request', 'Backend\Permission\PermissionController@create')->name('create');
    });
    Route::group(['prefix' => 'UmrahDashboard'], function () {
        Route::post('/add-selected-hotels-markup', 'Backend\Umrah\UmrahHotelController@addmarkupToSelectedHotels')->name('umrah.addmarkupToSelectedHotels');
        Route::get('/', 'Backend\Umrah\UmrahHotelController@index')->name('umrah.index');
        /** Umrah Hotel */
        Route::get('/view-all-umrah-hotels', 'Backend\Umrah\UmrahHotelController@index')->name('umrah.hotel');
        Route::post('/create', 'Backend\Umrah\UmrahHotelController@create')->name('umrah.create');
        Route::put('/update', 'Backend\Umrah\UmrahHotelController@update')->name('umrah.update');
        Route::delete('/delete/{id}', 'Backend\Umrah\UmrahHotelController@delete')->name('umrah.delete');
        /** Umrah Vehicle */
        Route::post('/add-selected-transport-markup', 'Backend\Umrah\UmrahVehicleSectorController@addmarkupToSelectedTransport')->name('umrah.addmarkupToSelectedTransport');
        Route::get('/vehicle-sector-price', 'Backend\Umrah\UmrahVehicleSectorController@index')->name('umrah.vehicle-sector-price');
        Route::post('/create-sectortransportPrice', 'Backend\Umrah\UmrahVehicleSectorController@create')->name('umrah.create-sectortransportPrice');
        Route::post('/create-newsectortransportPrice', 'Backend\Umrah\UmrahVehicleSectorController@newSector')->name('umrah.create-newSector');
        Route::post('/update-sectortransportPrice', 'Backend\Umrah\UmrahVehicleSectorController@update')->name('umrah.update-sectortransportPrice');
        Route::delete('/delete-sectortransportPrice/{id}', 'Backend\Umrah\UmrahVehicleSectorController@delete')->name('umrah.delete-sectortransportPrice');
        /** Umrah Visa */
        Route::post('/visas-create', 'Backend\Umrah\UmrahVisaController@create')->name('visas.visas-create');
        Route::put('/visas-update', 'Backend\Umrah\UmrahVisaController@update')->name('visas.visas-update');
        Route::delete('/visa-delete/{id}', 'Backend\Umrah\UmrahVisaController@delete')->name('visas.delete');
        Route::get('/visas', 'Backend\Umrah\UmrahVisaController@index')->name('umrah.visas');
        Route::get('/umrah-all-pages', 'Backend\Umrah\UmrahController@index')->name('umrah.umrah-all-pages');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('umrah.update-umrah-page');
        Route::get('/umrah-ubc', 'Backend\Umrah\UmrahController@umrahUBC')->name('umrah.umrah-ubc');
    });
    Route::group(['prefix'=>'subscribe'], function(){
        Route::get('/allSubscribers', 'Backend\Subscribe\SubscribeController@store')->name('subscribe.store');
    });
    Route::group(['prefix'=> 'Visa'], function(){
        Route::get('/all-visa-pages', 'Backend\Visa\VisaController@index')->name('visa.all-visa-pages');
        Route::post('/update-visa-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('visa.update-visa-page');
        Route::get('/new-visa-packages', 'Backend\Visa\CmsVisaPackageController@newVisaPackages')->name('visa.new-visa-packages');
        Route::post('/add-visa-package', 'Backend\Visa\CmsVisaPackageController@addVisaPackages')->name('visa.addVisaPackages');
        Route::put('/update-visa-package', 'Backend\Visa\CmsVisaPackageController@updateVisaPackages')->name('visa.updateVisaPackages');
        Route::delete('/delete/{id}', 'Backend\Visa\CmsVisaPackageController@delete')->name('visa.delete');
        Route::get('/all-visa-packages', 'Backend\Visa\CmsVisaPackageController@allVisaPackages')->name('visa.all-visa-packages');
    });
    Route::group(['prefix' => 'client-concent-form'], function(){
        Route::get('/', 'Backend\ConcentForm\ConcentFormController@index')->name('concentForm.index');
        Route::post('/add', 'Backend\Queries\CallBackQueryController@addContactDetails')->name('concentForm.store');
    });
    Route::group(['prefix'=>'world-tour-dashboard'], function(){
        Route::get('/all-world-tour-details', 'Backend\Tours\World\WorldTourController@index')->name('world-tour.all-world-tour-details');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('world-tour.update-world-tour-page');
    });
    Route::group(['prefix'=>'study-immigration-dashboard'], function(){
        Route::get('/all-immigration-details', 'Backend\StudyImmigration\StudyImmigrationController@index')->name('study-immigration-dashboard.index');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('study-immigration-dashboard.update');
    });
    Route::group(['prefix'=>'pakistan-tour-dashboard'], function(){
        Route::get('/all-pakistan-tour-details', 'Backend\Tours\Pakistan\PakistanTourController@index')->name('pakistan-tour.all-pakistan-tour-details');
        Route::delete('/delete/{id}', 'Backend\Pages\Site\ContentController@deletePageContent')->name('pakistan-tour-dashboard.delete');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('pakistan-tour.update-pakistan-tour-page');
    });
    Route::group(['prefix'=>'hajj-dashboard'], function(){
        Route::get('/', 'Backend\Hajj\HajjController@index')->name('hajj.hajj-dashboard');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('hajj.update-hajj-dashboard');
    });
    Route::group(['prefix' => 'content'], function() {
        Route::get('/newpage', 'Backend\Umrah\UmrahController@newPage')->name('content.new-page');
        Route::get('/get-all-parent', 'Backend\Pages\Site\ParentController@index')->name('content.parentPage');
        Route::get('/get-parent-by-id/{id}', 'Backend\Pages\Site\ParentController@getParentById')->name('content.get-parent-by-id');
        Route::post('/add-new-page', 'Backend\Pages\Site\ContentController@addNewContent')->name('content.add-new-page');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('content.update-new-page');
    });
    Route::group(['prefix' => 'hotel-dashboard'], function(){
        Route::get('/all-hotel-pages', 'Backend\Hotels\HotelController@index')->name('hotel.all-hotel-pages');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('content.update-new-page');
    });
    Route::group(['prefix' => 'manage-hotel'], function(){
        Route::match(['get', 'post'],'/hotels', 'Backend\ArabianOryx\ManageHotelController@index')->name('manageHotel.index');
        Route::match(['get', 'post'],'/leads', 'Backend\ArabianOryx\ManageLeadController@index')->name('leads.index');
        Route::match(['get', 'post'],'/bookings', 'Backend\ArabianOryx\ManageShoppingController@index')->name('bookings.index');
        Route::match(['get', 'post'],'/bookings-hotel', 'Backend\ArabianOryx\ManageShoppingController@getHotelDetails')->name('bookings.hotelDetails');
        Route::match(['get', 'post'],'/cancellationShopping', 'Website\ArabianOryx\ArbianOryxShoppingCancellationController@index_')->name('cancellation.index_');
    });
    Route::group(['prefix' => 'hotel-markup'], function(){
        Route::match(['get', 'post'],'/markup', 'Backend\ArabianOryx\ManageMarkupController@index')->name('hotel-markup.index');
        Route::post('/store', 'Backend\ArabianOryx\ManageMarkupController@store')->name('hotel-markup.store');
        Route::post('/update', 'Backend\ArabianOryx\ManageMarkupController@update')->name('hotel-markup.update');
        Route::delete('/delete/{id}', 'Backend\ArabianOryx\ManageMarkupController@destroy')->name('hotel-markup.delete');
    });
    Route::group(['prefix' => 'airlineContent'], function(){
        Route::get('/all-airlines-content', 'Backend\Pages\Airline\AirlineController@index')->name('all-airlines-details');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('content.update-new-page');
    });
    Route::group(['prefix' => 'reports'], function(){
        Route::match(['get', 'post'],'/', 'Backend\Reports\ReportController@index')->name('cmsQueries');
        Route::match(['get', 'post'], '/visa-report', 'Backend\Reports\VisitVisaController@index')->name('visa-report.index');
        Route::match(['get', 'post'], '/study-report', 'Backend\Reports\StudyVisaController@index')->name('visa-report.index');
    });
    Route::group(['prefix' => 'branches'], function(){
        Route::get('/', 'Backend\Branches\BranchesController@index')->name('branches.index');
        Route::post('/store', 'Backend\Branches\BranchesController@storeBranch')->name('branches.update');
    });

    Route::group(['prefix'=> 'bankAccounts'], function(){
        Route::get('/', 'Backend\Banks\BankController@index')->name('bankAccounts.index');
        Route::post('/store', 'Backend\Banks\BankController@storeBankAccount')->name('bankAccounts.storeBankAccount');
    });
    Route::group(['prefix' => 'users'], function(){
        Route::get('/', 'Backend\User\UserController@index')->name('users.index');
        Route::get('/permissions/{id}', 'Backend\User\UserController@permissions')->name('users.permissions');
        Route::post('/add', 'Backend\User\UserController@add')->name('user.add');
        Route::post('/update', 'Backend\User\UserController@update')->name('user.update');
        Route::delete('/destroy/{id}', 'Backend\User\UserController@destroy')->name('user.destroy');
        Route::get('/user-profile/{id}', 'Backend\User\UserController@UserPasswordUpdate')->name('user.updatePassword');
    });
    Route::group(['prefix'=> 'franchise'], function(){
        Route::get('/dashboard', 'Backend\Franchise\FranchiseController@index')->name('franchise.index');
        Route::post('/update-new-page', 'Backend\Pages\Site\ContentController@updatePageContent')->name('hajj.update-hajj-dashboard');

    });
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::post('/password', [PasswordController::class, 'update'])->name('password.update');
});
require __DIR__ . '/auth.php';
