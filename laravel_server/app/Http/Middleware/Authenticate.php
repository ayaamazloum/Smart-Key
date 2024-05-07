<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;
use App\Models\User;
use Carbon\Carbon;

class Authenticate extends Middleware
{
    public function handle($request, Closure $next)
    {
        if (!Auth::check()) {
            return response()->json(['error' => 'Unauthenticated.'], 401);
        }
        
        $user = Auth::user();

        if (!$this->isValidUser($user)) {
            Auth::logout();
            
            $user->delete();

            return response()->json(['error' => 'Invitation expired.'], 401);
        }

        return $next($request);
    }

    protected function isValidUser($user)
    {
        $now = Carbon::now();

        return $user->end_date >= $now;
    }

    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo(Request $request): ?string
    {
        return $request->expectsJson() ? null : route('login');
    }
}
