<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Arduino;
use App\Models\Log;

class ArduinoController extends Controller
{
    public function getKnockPattern(Request $request, Arduino $arduino)
    {
        $request_key = explode(' ', $request->header('Authorization'))[1];
        $arduino = Arduino::where('key', $request_key)->first();

        return response()->json(['status' => 'success', 'knockPattern' => $arduino->knock_pattern]);
    }

    public function log(Request $request) {
        $request_key = explode(' ', $request->header('Authorization'))[1];
        $arduino = Arduino::where('key', $request_key)->first();

        Log::create([
            'log' => $request->log,
            'arduino_id' => $arduino->id,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Log added successfully.',
        ]);
    }
}
