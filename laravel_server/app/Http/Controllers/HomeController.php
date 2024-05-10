<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\MembersAtHome;
use App\Models\Arduino;
use App\Models\Log;

class HomeController extends Controller
{
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

        // $arduino_id = Auth::user()->arduino_id;
        
        $logs = Log::whereDate('created_at', $request->date)->where('arduino_id', 1)->get();

        return response()->json([
            'status' => 'success',
            'logs' => $logs,
        ]);
    }
}
