<?php

namespace App\Libraries;
class ServerProvider
{
    public static function info($request): array
    {
        $clientIp = $request->header('X-Forwarded-For') ?? $request->ip();
        $serverIp = gethostbyname(gethostname());
        $route = $request->route();
        $routeName = $route?->getName();
        $actionName = $route?->getActionName();
        $resolvedPageName = $pageName ?? $routeName ?? $actionName ?? 'Unknown';
        return [
            'serverIp' => $serverIp ?? null,
            'clientIp' => $clientIp ?? null,
            'pageName' => $resolvedPageName ?? null,
            ];
    }
}
