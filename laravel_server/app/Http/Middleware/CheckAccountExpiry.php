<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

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
            $carbonEndDate = Carbon::parse($user->end_date);

            if($now->gt($carbonEndDate)) {
                Auth::logout();
                Invitation::where('email', $user->email)->delete();
                $user->delete();

                return response()->json(['status' => 'error', 'message' => 'Invitation expired.'], 401);
            }
        }
        return $next($request);
    }
}
