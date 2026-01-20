<?php

namespace App\Http\Controllers\Website\Ticketing;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use App\Libraries\rest_api\AllowOnlyValidInputProvider;
use App\Libraries\rest_api\AirTicketingMethodProvider;
use App\Libraries\rest_api\AirShoppingProvider;

class ChunkedFlightSearchController extends Controller
{
    /**
     * Handle chunked flight search request
     * Returns partial results as providers respond
     */
    public function chunkedFlightSearch(Request $request)
    {
        // Validate input
        $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInput(
            AirTicketingMethodProvider::params($request->input(), 'p')
        );

        if (!empty($allowOnlyValidInputProvider)) {
            return response()->json([
                'error' => $allowOnlyValidInputProvider,
                'fetchMore' => false
            ], 400);
        }

        // Get or generate search ID
        $searchId = $request->input('searchId', uniqid('search_', true));

        // Get providers list (comma-separated string from frontend)
        $providersString = $request->input('providers', 'Sabre');
        $providers = array_filter(array_map('trim', explode(',', $providersString)));

        if (empty($providers)) {
            return response()->json([
                'error' => 'No providers available',
                'fetchMore' => false,
                'searchId' => $searchId
            ], 400);
        }

        // Initialize search state if this is a new search
        $cacheKey = "flight_search_{$searchId}";
        $searchState = Cache::get($cacheKey, [
            'searchId' => $searchId,
            'providers' => $providers,
            'processedProviders' => [],
            'pendingProviders' => $providers,
            'results' => [],
            'errors' => [],
            'startedAt' => now()->timestamp
        ]);

        // Get the next provider to query
        $nextProvider = array_shift($searchState['pendingProviders']);

        if ($nextProvider) {
            try {
                // Make request to the provider
                $providerRequest = new Request($request->all());
                $response = AirShoppingProvider::cheapestFareAirshoppingReponse(
                    $providerRequest,
                    $nextProvider
                );

                // Store result if valid
                if (!empty($response) && is_array($response) && !isset($response['error'])) {
                    $searchState['results'][] = [
                        'provider' => $nextProvider,
                        'data' => $response
                    ];
                } else {
                    $searchState['errors'][] = [
                        'provider' => $nextProvider,
                        'error' => $response['error'] ?? 'No data returned'
                    ];
                }

                // Mark provider as processed
                $searchState['processedProviders'][] = $nextProvider;

            } catch (\Exception $e) {
                // Log error and mark provider as processed
                $searchState['errors'][] = [
                    'provider' => $nextProvider,
                    'error' => $e->getMessage()
                ];
                $searchState['processedProviders'][] = $nextProvider;
            }
        }

        // Determine if there are more providers to query
        $fetchMore = !empty($searchState['pendingProviders']);

        // Update cache with TTL of 5 minutes
        if ($fetchMore) {
            Cache::put($cacheKey, $searchState, now()->addMinutes(5));
        } else {
            // Clean up cache after final response
            Cache::forget($cacheKey);
        }

        // Prepare response
        return response()->json([
            'searchId' => $searchId,
            'fetchMore' => $fetchMore,
            'data' => $searchState['results'],
            'totalProviders' => count($providers),
            'processedCount' => count($searchState['processedProviders']),
            'remainingCount' => count($searchState['pendingProviders']),
            'errors' => $searchState['errors'],
            'latestProvider' => $nextProvider,
            'latestResult' => end($searchState['results']) ?: null
        ]);
    }

    /**
     * Alternative implementation: Process all providers in background
     * and return results incrementally
     */
    public function chunkedFlightSearchParallel(Request $request)
    {
        // Validate input
        $allowOnlyValidInputProvider = AllowOnlyValidInputProvider::allowOnlyValidInput(
            AirTicketingMethodProvider::params($request->input(), 'p')
        );

        if (!empty($allowOnlyValidInputProvider)) {
            return response()->json([
                'error' => $allowOnlyValidInputProvider,
                'fetchMore' => false
            ], 400);
        }

        // Get or generate search ID
        $searchId = $request->input('searchId');

        if (!$searchId) {
            // This is a new search - generate ID and start processing
            $searchId = uniqid('search_', true);

            $providersString = $request->input('providers', 'Sabre');
            $providers = array_filter(array_map('trim', explode(',', $providersString)));

            // Initialize cache
            $cacheKey = "flight_search_{$searchId}";
            Cache::put($cacheKey, [
                'searchId' => $searchId,
                'providers' => $providers,
                'results' => [],
                'completed' => [],
                'total' => count($providers),
                'startedAt' => now()->timestamp
            ], now()->addMinutes(5));

            // Dispatch async jobs to process each provider
            foreach ($providers as $provider) {
                $this->processProviderAsync($searchId, $provider, $request->all());
            }

            return response()->json([
                'searchId' => $searchId,
                'fetchMore' => true,
                'data' => [],
                'totalProviders' => count($providers),
                'processedCount' => 0
            ]);
        }

        // This is a polling request - return accumulated results
        $cacheKey = "flight_search_{$searchId}";
        $searchState = Cache::get($cacheKey);

        if (!$searchState) {
            return response()->json([
                'error' => 'Search session expired or not found',
                'fetchMore' => false
            ], 404);
        }

        $fetchMore = count($searchState['completed']) < $searchState['total'];

        // Clean up if complete
        if (!$fetchMore) {
            Cache::forget($cacheKey);
        }

        return response()->json([
            'searchId' => $searchId,
            'fetchMore' => $fetchMore,
            'data' => $searchState['results'],
            'totalProviders' => $searchState['total'],
            'processedCount' => count($searchState['completed']),
            'newResults' => $this->getNewResults($searchState, $request->input('lastCount', 0))
        ]);
    }

    /**
     * Process provider asynchronously (simulated - in production use Laravel Jobs)
     */
    private function processProviderAsync($searchId, $provider, $requestData)
    {
        // In production, dispatch this to a queue job
        // For now, we'll process synchronously in background

        try {
            $request = new Request($requestData);
            $response = AirShoppingProvider::cheapestFareAirshoppingReponse($request, $provider);

            $cacheKey = "flight_search_{$searchId}";
            $searchState = Cache::get($cacheKey);

            if ($searchState && !empty($response) && is_array($response) && !isset($response['error'])) {
                $searchState['results'][] = [
                    'provider' => $provider,
                    'data' => $response
                ];
                $searchState['completed'][] = $provider;
                Cache::put($cacheKey, $searchState, now()->addMinutes(5));
            }
        } catch (\Exception $e) {
            // Log error
            \Log::error("Provider {$provider} failed for search {$searchId}: " . $e->getMessage());
        }
    }

    /**
     * Get only new results since last poll
     */
    private function getNewResults($searchState, $lastCount)
    {
        $allResults = $searchState['results'];
        return array_slice($allResults, $lastCount);
    }
}
