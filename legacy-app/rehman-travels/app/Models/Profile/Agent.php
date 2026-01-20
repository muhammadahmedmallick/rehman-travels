<?php

namespace App\Models\Profile;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Support\Facades\DB;

class Agent extends Authenticatable {

    use HasApiTokens,
        HasFactory,
        Notifiable;

    protected $guard = 'agent';
    protected $fillable = [
        'id',
        'parentId',
        'secretId',
        'userName',
        'email',
        'password',
        'clientSecret',
        'grantType',
        'userType',
        'portalType'
    ];
    protected $hidden = [
        'password',
        'remember_token',
    ];
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public static function agentDetail($agentId) {
        return AgentDetail::find(['agentId' => $agentId])->first();
    }

    public function agent_detail() {
        return $this->belongsTo(AgentDetail::class);
    }

    public function user() {
        return $this->belongsTo(User::class, 'agentId', 'id');
    }

    protected static function currentAgentLoggedInfo($email) {
        return DB::table('agents')
            ->select("id as vendorId", "parentId as agentId", "email","password","userName", "companyName","secretId","clientSecret","grantType","scope","accountStatus",
             "markupType as mrkupType", "created_at", DB::raw('(CASE WHEN userType="sub_agent" THEN
            (SELECT parentId FROM agents WHERE id=parentId)
            ELSE 0 END) AS parentId'), 'userType', DB::raw('(CASE
            WHEN portalType="owner" THEN "b2c"
            WHEN userType="sub_agent" THEN "b2b2b2c"
            WHEN userType="agent" THEN "b2b2c"
            END) AS markupType'), DB::raw('(CASE
            WHEN userType="owner" THEN "b2c"
            WHEN userType="agent" THEN "b2b"
            WHEN userType="sub_agent" THEN "b2b"
            END) AS oaMarkupType'), DB::raw('(CASE
            WHEN userType="sub_agent" THEN "b2b2b"
            END) asMarkupType'), 'portalType', DB::raw('(CASE
            WHEN userType="agent" THEN "owner"
            WHEN userType="sub_agent" THEN "owner"
            END) oaPortalType'), DB::raw('(CASE
            WHEN userType="sub_agent" THEN "share"
            END) asPortalType'))
                        ->where('email', $email)
                        ->get()->first();
    }

    protected static function markupOnAgent($id) {
        return DB::table('agents as ag')
                        ->select("id as vendorId", "parentId as agentId", "email", "userName", "companyName", "created_at", DB::raw('(CASE WHEN userType="sub_agent" THEN
                    (SELECT (CASE WHEN parentId is null THEN 0 ELSE parentId END) FROM agents WHERE id=(SELECT id FROM agents where id=ag.parentId))
                    ELSE 0 END) AS parentId'), 'userType', DB::raw('(CASE
                    WHEN portalType="owner" THEN "b2c"
                    WHEN userType="sub_agent" THEN "b2b2b2c"
                    WHEN userType="agent" THEN "b2b2c"
                    END) AS markupType'), DB::raw('(CASE
                    WHEN (CASE WHEN userType="owner" THEN "b2c" END) THEN null
                    WHEN userType="agent" THEN "b2b"
                    WHEN userType="sub_agent" THEN "b2b"
                    END) AS oaMarkupType'), DB::raw('(CASE
                    WHEN userType="sub_agent" THEN "b2b2b"
                    END) asMarkupType'), 'portalType', DB::raw('(CASE
                    WHEN userType="agent" THEN "owner"
                    WHEN userType="sub_agent" THEN "owner"
                    END) oaPortalType'), DB::raw('(CASE
                    WHEN userType="sub_agent" THEN "share"
                    END) asPortalType')
                        )
                        ->where('id', $id)
                        ->get()->first();
    }

  public function __destruct() {
        DB::disconnect();
    }

}
