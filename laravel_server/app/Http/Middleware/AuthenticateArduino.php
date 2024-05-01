<?php

namespace App\Http\Middleware;

use Closure;
use App\Models\Arduino;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AuthenticateArduino
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next)
    {
        $request_key = explode(" ", $request->header('Authorization'))[1];
        $arduino_key = Arduino::where('key', $request_key)->first();

        if (!$arduino_key) {
            return response()->json(['error' => 'Arduino not found'], 404);
        }

        return $next($request);
    }
}
