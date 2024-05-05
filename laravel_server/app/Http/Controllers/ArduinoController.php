<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Arduino;

class ArduinoController extends Controller
{
    public function getKnockPattern(Request $request, Arduino $arduino)
    {
        $request_key = explode(' ', $request->header('Authorization'))[1];
        $arduino = Arduino::where('key', $request_key)->first();

        return response()->json(['status' => 'success', 'knockPattern' => $arduino->knock_pattern]);
    }
}
