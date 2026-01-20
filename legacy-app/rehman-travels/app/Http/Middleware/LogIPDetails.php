<?php
namespace App\Http\Middleware;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class LogIPDetails
{
    public function handle(Request $request, Closure $next)
    {
        $clientIp = $request->header('X-Forwarded-For') ?? $request->ip();
        $serverIp = gethostbyname(gethostname());
        $isPrivateClient = !filter_var($clientIp, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $isPrivateServer = !filter_var($serverIp, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $logData = [
            'reqDateTime' => now()->toDateTimeString(),
            'fullUrl' => $request->fullUrl(),
            'method' => $request->method(),
            'referer' => $request->headers->get('referer', 'N/A'),
            'userAgent' => $request->userAgent(),
            'clientIp' => $clientIp,
            'clientIpType' => $isPrivateClient ? 'Private/Local' : 'Public',
            'serverIp' => $serverIp,
            'serverIpType' => $isPrivateServer ? 'Private/Local' : 'Public',

        ];
       Log::channel('ip_log')->info('IP Details', $logData);
        return $next($request);
    }
}

