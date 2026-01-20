<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Models\IpLog;
use App\Models\Ticketing\FlightItineraryInfo;

class LogIp
{
    public function handle(Request $request, Closure $next, $pageName = null)
    {
        $clientIp = $request->header('X-Forwarded-For') ?? $request->ip();
        $sessionId = $request->session()->getId() ?? null;
        $sessionToken = $request->session()->token() ?? null;
        $route = $request->route();
        $routeName = $route?->getName();
        $actionName = $route?->getActionName();
        $resolvedPageName = $pageName ?? $routeName ?? $actionName ?? 'Unknown';
        $flightItineraryInfo = FlightItineraryInfo::__duplicate($request);
        if (count($flightItineraryInfo) >= 1):
            $recentAttempts = IpLog::__count($clientIp, $sessionId, $sessionToken, 'new');
            if ($recentAttempts <= 0):
                $lastId = IpLog::__create($request, $sessionId, $sessionToken, $resolvedPageName, 'You has been created PNR successfully.');
                $request->lastId = $lastId ?? 0;
            endif;
            IpLog::__blocked($clientIp, $sessionId, $sessionToken);
            abort(429, 'Too many attempts. Your IP has been temporarily blocked.');
        else:
            $request->lastId = IpLog::__create($request, $sessionId, $sessionToken, $resolvedPageName);
        endif;
        return $next($request);
    }
}

