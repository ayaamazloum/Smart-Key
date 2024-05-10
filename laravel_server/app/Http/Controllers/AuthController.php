<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\User;
use App\Models\Role;
use App\Models\Invitation;
use App\Models\MembersAtHome;
use App\Models\Arduino;
use Carbon\Carbon;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);
        $credentials = $request->only('email', 'password');

        $token = Auth::attempt($credentials);
        if (!$token) {
            return response()->json([
                'status' => 'error',
                'message' => 'Unauthorized',
            ], 401);
        }

        $user = Auth::user();

        $isHome = MembersAtHome::where('user_id', $user->id)->first();

        return response()->json([
                'status' => 'success',
                'user' => $user,
                'userType' => $user->role->role,
                'isHome' => !$isHome ? false : true,
                'authorisation' => [
                    'token' => $token,
                    'type' => 'bearer',
                ]
            ]);

    }

    public function register(Request $request){
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255',
            'key' => 'required|string',
            'password' => 'required|string|min:8',
        ]);
        
        $existingUser = User::where('email', $request->email)->first();
        if ($existingUser) {
            return response()->json(['status' => 'error', 'message' => 'The email is already registered.'], 422);
        }
        
        $invitation = Invitation::where('email', $request->email)->first();
        if (!$invitation) {
            return response()->json(['status' => 'error', 'message' => 'The email is not invited.'], 422);
        }

        $now = Carbon::now();
        if($invitation->start_date > $now) {
            return response()->json(['status' => 'error', 'message' => 'Cannot register before invitation start date.'], 422);
        }

        if($request->key != $invitation->key) {
            return response()->json(['status' => 'error', 'message' => 'Incorrect invitation key.'], 404);
        }
        
        $role = Role::where('role', $invitation->type)->first();
        if (!$role) {
            return response()->json(['status' => 'error', 'message' => 'Role not found.'], 404);
        }

        $arduino = Arduino::where('id', $invitation->arduino_id)->first();
        if (!$arduino) {
            return response()->json(['status' => 'error', 'message' => 'Arduino not found.'], 404);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'arduino_id' => $arduino->id,
            'role_id' => $role->id,
            'start_date' => $invitation-> start_date,
            'end_date' => $invitation-> end_date,
        ]);

        $token = Auth::login($user);
        return response()->json([
            'status' => 'success',
            'message' => 'User created successfully.',
            'user' => $user,
            'userType' => $role->role,
            'isHome' => false,
            'authorisation' => [
                'token' => $token,
                'type' => 'bearer',
            ]
        ]);
    }

    public function logout()
    {
        Auth::logout();
        return response()->json([
            'status' => 'success',
            'message' => 'Successfully logged out',
        ]);
    }

    public function refresh()
    {
        return response()->json([
            'status' => 'success',
            'user' => Auth::user(),
            'authorisation' => [
                'token' => Auth::refresh(),
                'type' => 'bearer',
            ]
        ]);
    }

}