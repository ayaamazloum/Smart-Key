<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\MembersAtHome;
use App\Models\Arduino;
use App\Models\User;
use App\Models\Log;

class HomeController extends Controller
{
    public function getMembersAtHome(Request $request) {
        $arduino_id = Auth::user()->arduino_id;

        $userIds = MembersAtHome::where('arduino_id', $arduino_id)->pluck('user_id')->toArray();
        $members = User::whereIn('id', $userIds)->pluck('name')->toArray();

        return response()->json([
            'status' => 'success',
            'members' => $members,
        ]);
    }

    public function markHome(Request $request) {
        $user = Auth::user();

        MembersAtHome::create([
            'user_id' => $user->id,
            'arduino_id' => $user->arduino_id,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Marked as home successfully.',
        ]);
    }

    public function markNotHome(Request $request) {
        $user = Auth::user();

        MembersAtHome::where('user_id', $user->id)->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Marked as not home successfully.',
        ]);
    }

    public function log(Request $request) {
        $user = Auth::user();

        Log::create([
            'log' => $user->name . ' ' . $request->log,
            'arduino_id' => $user->arduino_id,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Log added successfully.',
        ]);
    }

    public function getLogs(Request $request) {
        $request->validate([
            'date' => 'required|string'
        ]);

        $arduino_id = Auth::user()->arduino_id;
        
        $logs = Log::whereDate('created_at', $request->date)->where('arduino_id', $arduino_id)->get();

        return response()->json([
            'status' => 'success',
            'logs' => $logs,
        ]);
    }

    public function changePasscode(Request $request)
    {
        $request->validate([
            'currentPasscode' => 'required|string|min:8',
            'newPasscode' => 'required|string|min:8',
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
}
