<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\User;

class UserController extends Controller
{
    public function validateUser(Request $request)
    {
        return response()->json([
            'status' => 'success', 
            'message' => 'User validation was successful.',
        ]); 
    }

        public function updateProfile(Request $request)
    {
        $user = auth()->user();

        if ($request->has('newProfilePicture')) {
            $imageData = $request->input('newProfilePicture');
            $imageName = 'profile_' . $user->id . '_' . uniqid() . '.png';
            $imagePath = 'profile_pictures/' . $imageName;
            Storage::disk('public')->put($imagePath, base64_decode($imageData));

            $user->profile_picture = $imageName;
        }

        if ($request->has('name')) {
            $user->name = $request->input('name');
        }

        $user->save();

        return response()->json([
            'status' => 'success', 
            'message' => 'Profile updated successfully',
            'profilePicture' => $imageName ?? ''
        ]);
    }
}
