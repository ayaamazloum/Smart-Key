<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;
use App\Models\Device;

class NotificationController extends Controller
{
    public function sendNotification()
    {
        $title = 'Visitor Notification';
        $body = 'Someone is at your door, ringing the bell';
        $token = 'euDMrQEGTAyIAXeMmhlyLB:APA91bHxWRbNyfdBev5WxQ1U2x97AWKzwMub6L782pVk_asYkr9m7NAN3hJXp60SwwSSrMtw9ySQ4AHOKfiDXtRNoUoU4XHkeem0HGIhL9V4TWyok3TNdCejsgzMvgy2zctB1g6mpJFI';

        $firebase = (new Factory())
        ->withServiceAccount(__DIR__.'/../../../config/firebase_credentials.json');

        $messaging = $firebase->createMessaging();

        $message = CloudMessage::withTarget('token', $token)
            ->withNotification(Notification::create($title, $body));

        $messaging->send($message);

        return response()->json(['message' => 'Notification sent successfully']);
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
