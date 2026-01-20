<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Models\IpLog;

class GlobalIpRateLimiter
{
    public function handle(Request $request, Closure $next)
    {
        $clientIp = $request->header('X-Forwarded-For') ?? $request->ip();
        $blockedIp = IpLog::where(['clientIp' => $clientIp, 'sessionId' => $request->session()->getId(),
            'sessionToken' => $request->session()->token(), 'version' => 'blocked'])->first();
        if (!empty($blockedIp) && $blockedIp->version == 'blocked'):
            abort(429, 'Too many attempts. Your IP has been temporarily blocked.');
        endif;
        return $next($request);
    }
}

