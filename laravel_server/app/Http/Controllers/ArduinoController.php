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

    public function changePasscode(Request $request)
    {
        $request->validate([
            'currentPasscode' => 'required|string|min:6',
            'newPasscode' => 'required|string|min:6',
        ]);

        $arduino_id = auth()->user()->arduino_id;

        $arduino = Arduino::find($arduino_id);

        if($request->currentPasscode != $arduino->passcode) {
            return response()->json(['status' => 'error', 'message' => 'Incorrect provided current passcode.'], 422);
        }
        
        $arduino->passcode = $request->newPasscode;
        $arduino->save();

        return response()->json(['status' => 'success', 'message' => 'Passcode changed successfully.']);
    }

    public function getKnock(Request $request)
    {
        $arduino_id = auth()->user()->arduino_id;

        $arduino = Arduino::findOrFail($arduino_id);

        return response()->json(['status' => 'success', 'knock' => $arduino->knock_pattern]);
    }

    public function changeKnock(Request $request)
    {
        $request->validate([
            'newPattern' => 'required|string',
        ]);

        $arduino_id = auth()->user()->arduino_id;

        $arduino = Arduino::find($arduino_id);
        
        $arduino->knock_pattern = $request->newPattern;
        $arduino->save();

        return response()->json(['status' => 'success', 'message' => 'Knock changed successfully.']);
    }
}
