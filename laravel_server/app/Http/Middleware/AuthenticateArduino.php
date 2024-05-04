<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use App\Models\Arduino;

class AuthenticateArduino
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        $request_key = explode(' ', $request->header('Authorization'))[1];
        $arduino = Arduino::where('key', $request_key)->first();

        if (!$arduino) {
            return response()->json(['error' => 'Unauthorized'], 404);
        }

        return $next($request);
    }
}
