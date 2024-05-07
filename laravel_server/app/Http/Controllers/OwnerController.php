<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Mail\InvitationEmail;
use App\Models\Invitation;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\Rule;

class OwnerController extends Controller
{
    public function sendInvitation(Request $request)
    {
        try {
            $request->validate([
                'email' => ['required', 'email', Rule::unique('invitations')]
            ]);
        } catch (ValidationException $e) {
            return response()->json(['status' => 'error', 'message' => 'The email has already been invited.'], 422);
        }
        
        $existingUser = User::where('email', $request->email)->exists();
        if ($existingUser) {
            return response()->json(['status' => 'error', 'message' => 'The email has already been registered.'], 422);
        }

        $request->validate([
            'type' => 'required|string',
        ]);

        $user_name = auth()->user()->name;
        $arduino_id = auth()->user()->arduino_id;

        try {
            $toEmail = $request['email'];
            $email_key = Str::random(8);

            $message = '<p><strong>Hello,</strong></p>
                <p>You have been invited to have access to '. $user_name . '\'s door system! Please use the code below when registering to Smart Key app.</p>
                <p>Invitation Code: <strong>'. $email_key. '</strong></p>
                <p>Best regards,</p>
                <p><em>Smart Key Team</em></p>';

            Mail::to($toEmail)->send(new InvitationEmail($message));

            $invitation = new Invitation();
            $invitation->email = $toEmail;
            $invitation->type = $request->type;
            $invitation->key = $email_key;
            $invitation->arduino_id = $arduino_id;
            if($request->start_date) {
                $invitation->start_date = $request->start_date;
            }
            if($request->end_date) {
                $invitation->end_date = $request->end_date;
            }
            $invitation->save();

            return response()->json(['status' => 'success', 'message' => 'Invitation sent successfully.']);
        } catch (\Throwable $th) {
            return response()->json(['status' => 'error', 'message' => $th->getMessage()]);
        }
    }
}
