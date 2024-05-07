<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\MembersAtHome;
use App\Models\Arduino;

class HomeController extends Controller
{
    public function markHome(Request $request) {
        $user = Auth::user();

        $member_at_home = MembersAtHome::create([
            'user_id' => $user->id,
            'arduino_id' => $user->arduino_id,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Marked as home successfully.',
        ]);
    }
}
