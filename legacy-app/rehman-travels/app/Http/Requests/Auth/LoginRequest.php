<?php

namespace App\Http\Requests\Auth;

use App\Events\RefreshAccessToken;
use Illuminate\Auth\Events\Lockout;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use App\Models\Profile\Agent;
use Illuminate\Support\Facades\DB;

class LoginRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ];
    }

    /**
     * Attempt to authenticate the request's credentials.
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function authenticate(): void
    {
        $this->ensureIsNotRateLimited();
        if (Auth::guard('agent')->attempt($this->only('email', 'password'), $this->boolean('remember'))) :
            $currentLoggedInProfile = Agent::currentAgentLoggedInfo($this->email);
            $currentLoggedInGuard = Auth::guard('agent')->user();
            session(self::__currentLoggedInProfile('agent', $currentLoggedInProfile, $currentLoggedInGuard));
        elseif (Auth::guard('user')->attempt($this->only('email', 'password'), $this->boolean('remember'))) :
            $currentLoggedInGuard = Auth::guard('user')->user();
            $agentInfo = Agent::find($currentLoggedInGuard->agentId);
            $currentLoggedInProfile = Agent::currentAgentLoggedInfo($agentInfo->email);
            session(self::__currentLoggedInProfile('user', $currentLoggedInProfile, $currentLoggedInGuard));
        else:
            RateLimiter::hit($this->throttleKey());
            throw ValidationException::withMessages([
                'email' => trans('auth.failed'),
            ]);
        endif;
        RateLimiter::clear($this->throttleKey());
    }

    /**
     * Ensure the login request is not rate limited.
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function ensureIsNotRateLimited(): void
    {
        if (! RateLimiter::tooManyAttempts($this->throttleKey(), 5)) {
            return;
        }
        event(new Lockout($this));
        $seconds = RateLimiter::availableIn($this->throttleKey());
        throw ValidationException::withMessages([
            'email' => trans('auth.throttle', [
                'seconds' => $seconds,
                'minutes' => ceil($seconds / 60),
            ]),
        ]);
    }

    /**
     * Get the rate limiting throttle key for the request.
     */
    public function throttleKey(): string
    {
        return Str::transliterate(Str::lower($this->input('email')).'|'.$this->ip());
    }

    private static function __currentLoggedInProfile($currentLoggedInUserType, $currentLoggedInProfile, $currentLoggedInGuard) {
        $currentLoggedIn = 'b'.$currentLoggedInProfile->vendorId.'b'.$currentLoggedInProfile->agentId.'b'.($currentLoggedInUserType == 'agent' ? 0 : $currentLoggedInGuard->id).'b'.$currentLoggedInUserType;
        event(new RefreshAccessToken('/b2b/ticketing',$currentLoggedInGuard,$currentLoggedIn));
        $session['currentLoggedIn'] = $currentLoggedIn;
        $session['vendorId'] = $currentLoggedInProfile->vendorId;
        $session['agentId'] = $currentLoggedInProfile->agentId;
        $session['parentId'] = (!empty($currentLoggedInProfile->parentId) ? $currentLoggedInProfile->parentId : $currentLoggedInProfile->agentId);
        $session['userId'] = ($currentLoggedInUserType == 'agent' ? 0 : $currentLoggedInGuard->id);
        $session['email'] = ($currentLoggedInUserType == 'agent' ? $currentLoggedInProfile->email : $currentLoggedInGuard->email);
        $session['userName'] = ($currentLoggedInUserType == 'agent' ? $currentLoggedInProfile->userName : $currentLoggedInGuard->userName);
        $session['companyName'] = $currentLoggedInProfile->companyName;
        $session['secretId'] =($currentLoggedInUserType == 'agent' ?  $currentLoggedInProfile->secretId : $currentLoggedInGuard->secretId);
        $session['clientSecret'] = ($currentLoggedInUserType == 'agent' ?  $currentLoggedInProfile->clientSecret : $currentLoggedInGuard->clientSecret);
        $session['grantType'] = ($currentLoggedInUserType == 'agent' ?  $currentLoggedInProfile->grantType : $currentLoggedInGuard->grantType);
        $session['scope'] = ($currentLoggedInUserType == 'agent' ?  $currentLoggedInProfile->scope : $currentLoggedInGuard->scope);
        $session['accountStatus'] = $currentLoggedInProfile->accountStatus;
        $session['joinDate'] = ($currentLoggedInUserType == 'agent' ? $currentLoggedInProfile->created_at : $currentLoggedInGuard->created_at);
        $session['activeType'] = $currentLoggedInUserType;
        $session['activeId'] = ($currentLoggedInUserType == 'agent' ? $currentLoggedInProfile->vendorId : $currentLoggedInGuard->id);
        $session['userType'] = $currentLoggedInProfile->userType;
        $session['markupType'] = $currentLoggedInProfile->markupType;
        $session['mrkupType'] = $currentLoggedInProfile->mrkupType;
        $session['asMarkupType'] = $currentLoggedInProfile->asMarkupType;
        $session['oaMarkupType'] = $currentLoggedInProfile->oaMarkupType;
        $session['portalType'] = $currentLoggedInProfile->portalType;
        $session['asPortalType'] = (!empty($profile->asPortalType) ? $currentLoggedInProfile->asPortalType : 0);
        $session['oaPortalType'] = $currentLoggedInProfile->oaPortalType;
        $session['password'] = ($currentLoggedInUserType == 'agent' ? $currentLoggedInProfile->password : $currentLoggedInGuard->password);
//        $session['permissions'] = self::__currentLoggedInAllPermission($currentLoggedInProfile->vendorId, $currentLoggedInProfile->agentId, ($currentLoggedInUserType == 'agent' ? 0 : $currentLoggedInGuard->id));
        return $session;
    }

    private static function __currentLoggedInAllPermission($agentId, $parentId, $userId) {
        $query = DB::table('permission_assigns as pa');
        $query->join('permissions as pr', 'pr.id', '=', 'pa.permissionId');
        $query->select('pr.id', 'pr.title', 'pa.agentId','pa.parentId','pa.userId','pa.moduleType', 'pa.permissionId');
        $query->where(['pa.agentId' => $agentId, 'pa.parentId' => $parentId, 'pa.userId' => $userId]);
        if ($query->count() > 0):
            $permissions = array();
            foreach ($query->get() as $row_set):
                $permissions[$row_set->moduleType][str_replace(" ", "", $row_set->title)] = $row_set->id;
            endforeach;
            return $permissions;
        endif;
    }

    public function logout() {
        if (Auth::guard('agent')->check()) :
            Auth::guard('agent')->logout();
        elseif (Auth::guard('user')->check()) :
            Auth::guard('user')->logout();
        endif;
        return redirect('agent-panel');
    }
}
