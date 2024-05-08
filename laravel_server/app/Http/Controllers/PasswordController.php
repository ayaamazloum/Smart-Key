<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\PasswordResetKey;
use App\Mail\ResetPasswordMail;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\Rule;
use Carbon\Carbon;
use Illuminate\Support\Facades\Hash;

class PasswordController extends Controller
{
    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email']
        ]);
        
        $user = User::where('email', $request->email)->exists();
        if (!$user) {
            return response()->json(['status' => 'error', 'message' => 'Email address is not registered.'], 422);
        }

        try {
            $toEmail = $request['email'];
            $key = Str::random(8);

            $message = '<p><strong>Hello,</strong></p>
                <p>Here is your password reset verification code. Please use it within 5 minutes to reset your Smart Key account password.</p>
                <p>Verification code: <strong>'. $key. '</strong></p>
                <p>Best regards,</p>
                <p><em>Smart Key Team</em></p>';

            Mail::to($toEmail)->send(new ResetPasswordMail($message));

            PasswordResetKey::create([
                'email' => $toEmail,
                'key' => $key,
            ]);

            return response()->json(['status' => 'success', 'message' => 'Verification code sent successfully.']);
        } catch (\Throwable $th) {
            return response()->json(['status' => 'error', 'message' => $th->getMessage()]);
        }
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'key' => 'required|string',
            'password' => 'required|string|min:8',
        ]);

        $lastKey = PasswordResetKey::latest()->where('email', $request->email)->where('key', $request->key)->first();

        $createdAt = Carbon::parse($lastKey->created_at);
        $now = Carbon::now();
        $isBefore5Minutes = $createdAt->addMinutes(5)->lte($now);
        
        if($isBefore5Minutes) {
            return response()->json(['status' => 'error', 'message' => 'The verification code must be used within 5 minutes maximum.'], 422);
        }
        
        $user = User::where('email', $request->email)->first();
        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json(['status' => 'success', 'message' => 'Password reset successfully.']);
    }
}
