<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckAccountExpiry
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = Auth::user();
        if($user->role->role === 'guest') {
            $now = Carbon::now();

            if (!$user->end_date > $now) {
                Auth::logout();
                $user->delete();

                return response()->json(['error' => 'Invitation expired.'], 401);
            }
        }
        return $next($request);
    }
}
