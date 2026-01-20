<?php

namespace App\Libraries;

use App\Models\IpLog;
use App\Libraries\ServerProvider;


class IpLogProvider
{
    protected static array $serverInfo;
    protected static string $serverIp;
    protected static string $clientIp;
    protected static int $lastId;
    protected static $request;
    private static string $sessionId;
    private static string $sessionToken;

    public function __construct($request)
    {
        $serverProvider = ServerProvider::info($request);
        self::$serverInfo = $serverProvider;
        self::$serverIp = $serverProvider['serverIp'];
        self::$clientIp = $serverProvider['clientIp'];
        self::$lastId = $request->lastId ?? 0;
        self::$request = $request;
        self::$sessionId = $request->session()->getId() ?? null;
        self::$sessionToken = $request->session()->token() ?? null;
    }

    public static function orderCount()
    {
        return IpLog::__orderCreateCount(self::$serverIp, self::$sessionId, self::$sessionToken);
    }

    public static function createOrUpdate($reason, $reference, $refType, $refNumber, $routes)
    {
        if (!empty(IpLog::find(self::$lastId))):
            IpLog::__update(self::$lastId, self::$sessionId, self::$sessionToken, $reason, $reference, $refType, $refNumber, $routes);
        else:
            self::$request->lastId = IpLog::__create(self::$request, self::$sessionId, self::$sessionToken, self::$serverInfo['pageName'], $reason, $reference, $refType, $refNumber, $routes);
        endif;
    }

    public static function __routes($params)
    {
        $routes = '';
        if ($params['ft'] == 'multi-trip'):
            $routes .= str_replace(",", "-", $params['ol']) . ',' . str_replace(",", "-", $params['dl']);
        else:
            $routes = $params['ol'] . '-' . $params['dl'];
            if ($params['ft'] == 'round-trip'):
                $routes .= ',' . $params['dl'] . '-' . $params['ol'];
            endif;
        endif;
        return $routes;
    }

    public static function blocked()
    {
        IpLog::__blocked(self::$clientIp, self::$sessionId, self::$sessionToken);
    }

    public static function all()
    {
        return IpLog::__all(self::$clientIp, self::$sessionId, self::$sessionToken);
    }

    public static function duplicate($firstName, $lastName, $refType, $routes)
    {
        return IpLog::__duplicate(self::$clientIp, self::$sessionId, self::$sessionToken, $firstName, $lastName, $refType, $routes);
    }

    public static function simultaneously($refType, $routes)
    {
        return IpLog::__simultaneously(self::$clientIp, self::$sessionId, self::$sessionToken, $refType, $routes);
    }

}

