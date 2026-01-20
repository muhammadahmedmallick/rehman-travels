<?php

namespace App\Console\Commands;

use App\Libraries\AccessTokenProvider;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Storage;

class RefreshAccessToken extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'RefreshAccessToken:RefreshAccessToken';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $accessToken = AccessTokenProvider::accessToken();
        if (!empty($accessToken['status']) && $accessToken['status'] == 'Success'):
//            return $accessToken["data"]["access_token"];
            Storage::put("AccessToken/RefreshAccessToken.json",json_encode($accessToken));
        endif;
    }
}
