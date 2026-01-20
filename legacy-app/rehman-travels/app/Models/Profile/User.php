<?php

namespace App\Models\Profile;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Models\Branches\Branch;
use Illuminate\Support\Facades\DB;
class User extends Authenticatable {

    use HasApiTokens,
        HasFactory,
        Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'userName',
        'email',
        'branchId',
        'designation',
        'password',
        'accountStatus',
        'department',
        'userType',
        'mobileNo',
        'phoneNo',
        'address',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
    protected $guard = 'user';

    public static function userDetail($userId) {
        return UserDetail::find(['userId' => $userId])->first();
    }

    protected static function markupOnUser($id) {
        return DB::table('users as us')
                        ->select("us.id", "us.agentId", "us.parentId", "us.userType", DB::raw('(CASE
                    WHEN us.userType="owner" THEN "b2c"
                    WHEN us.userType="agent" THEN "b2b2c"
                    WHEN us.userType="sub_agent" THEN "b2b2b2c"
                    END) AS markupType'))
                        ->where('us.id', $id)
                        ->get()->first();
    }
    public function branches(){
        return $this->belongsTo(Branch::class, 'branchId', 'id');
    }

  public function __destruct() {
        DB::disconnect();
    }
}
