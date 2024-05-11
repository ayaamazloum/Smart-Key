<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\PasswordController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\UserController;

Route::middleware('auth')->group(function () {
    Route::middleware('account')->group(function () {
        Route::middleware('role:owner')->group(function () {
            Route::get('membersAtHome', [HomeController::class, 'getMembersAtHome']);
            Route::post('changePasscode', [ArduinoController::class, 'changePasscode']);
            Route::get('knock', [ArduinoController::class, 'getKnock']);
            Route::post('changeKnock', [ArduinoController::class, 'changeKnock']);
        });
        
        Route::middleware('role:owner,family_member')->group(function () {
            Route::post('invite', [InvitationController::class, 'sendInvitation']);
            Route::post('logs', [HomeController::class, 'getLogs']);
            Route::get('invitations', [InvitationController::class, 'getAllInvitations']);
            Route::post('deleteInvitation', [InvitationController::class, 'deleteInvitation']);
        });

        Route::middleware('role:family_member,guest')->group(function () {
            Route::get('markHome', [HomeController::class, 'markHome']);
            Route::get('markNotHome', [HomeController::class, 'markNotHome']);
        });
                
        Route::post('updateProfile', [UserController::class, 'updateProfile']);
        Route::post('changePassword', [PasswordController::class, 'changePassword']);
        Route::post('log', [HomeController::class, 'log']);
        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('refresh', [AuthController::class, 'refresh']);
    });
});

Route::middleware('arduino')->group(function () {
    Route::get('knockPattern', [ArduinoController::class, 'getKnockPattern']);
    Route::post('arduinoLog', [ArduinoController::class, 'log']);
});

Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
Route::post('forgotPassword', [PasswordController::class, 'forgotPassword']);
Route::post('resetPassword', [PasswordController::class, 'resetPassword']);
Route::post('addDevice', [NotificationController::class, 'addDevice']);
Route::get('sendNotification', [NotificationController::class, 'sendNotification']);