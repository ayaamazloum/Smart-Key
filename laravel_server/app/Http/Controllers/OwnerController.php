<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
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
        $request->validate([
            'email' => ['required', 'email', Rule::unique('invitations')]
        ]);

        // $arduino_id = auth()->user()->arduino_id;

        try {
            $toEmail = $request['email'];
            $email_key = Str::random(8);

            $message = "<p><strong>Hello,</strong></p>
                <p>You have been invited to our platform! Please use the code below when resistering using ou mobile application.</p>
                <p>Invitation Code: <strong>". $email_key. "</strong></p>
                <p><em>Best regards,</em></p>
                <p>Smart Key Team</p>";

            Mail::to($toEmail)->send(new InvitationEmail($message));

            $invitation = new Invitation();
            $invitation->email = $toEmail;
            $invitation->key = $email_key;
            $invitation->arduino_id = 1; // Change this later ----------------
            $invitation->save();

            return response()->json(['status' => 'success', 'message' => 'Invitation sent successfully']);
        } catch (\Throwable $th) {
            return response()->json(['status' => 'error', 'message' => $th->getMessage()]);
        }
    }
}
