<?php

namespace App\Listeners;

use App\Events\RefreshAccessToken;
use App\Libraries\AccessTokenProvider;
use Illuminate\Support\Facades\Storage;

class RefreshAccessTokenFired
{
    /**
     * Create the event listener.
     *
     * @return void
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     *
     * @param  \App\Events\RefreshAccessToken  $refreshAccessToken
     * @return void
     */
    public function handle(RefreshAccessToken $refreshAccessToken)
    {
        $accessToken = AccessTokenProvider::accessToken($refreshAccessToken->loggedIn);
        if (!empty($accessToken['status']) && $accessToken['status'] == 'Success'):
            Storage::put('AccessToken/1182owner.json', json_encode($accessToken, true));
            return $accessToken["data"]["access_token"];
        endif;
    }
}
