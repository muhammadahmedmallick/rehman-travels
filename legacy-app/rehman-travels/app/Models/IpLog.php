<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class IpLog extends Model
{
    use HasFactory;

    protected $fillable = ['sessionId', 'sessionToken', 'clientIp', 'reqDateTime', 'fullUrl', 'method', 'referer', 'userAgent',
        'clientIpType', 'serverIp', 'serverIpType', 'pageName', 'scopeType', 'version', 'email', 'reason', 'refNumber', 'reference', 'routes'
    ];

    protected static function __count($clientIp, $sessionId, $sessionToken, $version)
    {
        return self::where(['clientIp' => $clientIp, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken, 'version' => $version])->count();
    }

    protected static function __orderCreateCount($clientIp, $sessionId, $sessionToken)
    {
        return self::where(['clientIp' => $clientIp, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken, 'version' => 'new', 'pageName' => 'orderCreate'])->count();
    }

    protected static function __create($request, $sessionId, $sessionToken, $pageName, $reason = null, $reference = null, $refType = null, $refNumber = null, $routes = null)
    {
        $clientIp = $request->header('X-Forwarded-For') ?? $request->ip();
        $serverIp = gethostbyname(gethostname());
        $isPrivateClient = !filter_var($clientIp, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $isPrivateServer = !filter_var($serverIp, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
        $log = self::create([
            'sessionId' => $sessionId,
            'sessionToken' => $sessionToken,
            'email' => 'ceo@rehmantravel.com',
            'serverIp' => $serverIp,
            'clientIp' => $clientIp,
            'reqDateTime' => now()->toDateTimeString(),
            'fullUrl' => $request->fullUrl(),
            'method' => $request->method(),
            'referer' => $request->headers->get('referer', 'null'),
            'userAgent' => $request->userAgent(),
            'clientIpType' => $isPrivateClient ? 'Private/Local' : 'Public',
            'serverIpType' => $isPrivateServer ? 'Private/Local' : 'Public',
            'pageName' => $pageName,
            'scopeType' => 'Rehman Travel',
            'version' => 'new',
            'reason' => $reason ?? null,
            'reference' => $reference ?? null,
            'refType' => $refType ?? null,
            'refNumber' => $refNumber ?? null,
            'routes' => $routes ?? null,
        ]);
        return $log->id;
    }

    protected static function __update($lastId, $sessionId, $sessionToken, $reason, $reference, $refType, $refNumber, $routes)
    {
        self::where(['id' => $lastId])->update([
            'reason' => $reason ?? null, 'reference' => $reference ?? null,
            'refNumber' => $refNumber ?? null, 'routes' => $routes ?? null,
            'refType' => $refType ?? null,
        ]);
    }

    protected static function __blocked($clientIp, $sessionId, $sessionToken)
    {
        self::where(['clientIp' => $clientIp, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken, 'version' => 'new'])->update(['version' => 'blocked']);
    }

    protected static function __all($clientIp, $sessionId, $sessionToken)
    {
        return self::where(['clientIp' => $clientIp, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken])
            ->whereNotNull('reference')
            ->whereDate('created_at', date('Y-m-d'))
            ->get('reference');
    }

    protected static function __duplicate($clientIp, $sessionId, $sessionToken, $firstName, $lastName, $refType, $routes)
    {
        return DB::table('ip_logs')
            ->where('reference', 'like', '%"firstName":"' . $firstName . '"%')
            ->where('reference', 'like', '%"lastName":"' . $lastName . '"%')
            ->whereNotNull('reference')->whereNotNull('refNumber')
            ->where(['routes' => $routes, 'refType' => $refType, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken])
            ->whereDate('created_at', date("Y-m-d"))
            ->count();
    }

    protected static function __simultaneously($clientIp, $sessionId, $sessionToken, $refType, $routes)
    {
        return DB::table('ip_logs')
            ->where(['routes' => $routes, 'refType' => $refType, 'sessionId' => $sessionId, 'sessionToken' => $sessionToken])
            ->whereDate('created_at', date("Y-m-d"))
            ->where('created_at', '>=', now()->subMinute())
            ->count();
    }

}
