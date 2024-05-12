<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use App\Models\Device;
use App\Models\Notification as AppNotification;
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

        AppNotification::create([
            'text' => $body,
            'read' => false,
            'arduino_id' => $arduino->id,
        ]);

        return response()->json(['message' => 'Notifications sent successfully']);
    }

    public function getNotifications(Request $request) {
        $arduino_id = auth()->user()->arduino_id;
        
        $notifications = AppNotification::where('arduino_id', $arduino_id)->get();
        $unreadNotifications = AppNotification::where('arduino_id', $arduino_id)->where('read', false)->get();

        foreach ($unreadNotifications as $notification) {
            $notification->read = true;
            $notification->save();
        }

        return response()->json([
            'status' => 'success',
            'notifications' => $notifications,
        ]);
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
