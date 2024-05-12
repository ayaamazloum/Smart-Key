<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use App\Models\Device;
use App\Models\Arduino;

class NotificationController extends Controller
{
    public function sendNotification(Request $request)
    {
        $title = 'Visitor Notice';
        $body = 'Someone is at your door, ringing the bell';

        $request_key = explode(' ', $request->header('Authorization'))[1];
        $arduino = Arduino::where('key', $request_key)->first();

        $tokens = Device::where('arduino_id', $arduino->id)->pluck('fcm_token')->toArray();

        $firebase = (new Factory())
        ->withServiceAccount(__DIR__.'/../../../config/firebase_credentials.json');

        $messaging = $firebase->createMessaging();

        foreach ($tokens as $token) {
            $message = CloudMessage::withTarget('token', $token)
                ->withNotification(Notification::create($title, $body));
        
            $messaging->send($message);
        }

        return response()->json(['message' => 'Notifications sent successfully']);
    }

    public function addDevice(Request $request) {
        $request->validate([
            'token' =>'required|string',
        ]);

        Device::create([
            'fcm_token' => $request->token,
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Device added successfully.',
        ]);
    }
}
