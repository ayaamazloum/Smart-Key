<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\PasswordController;
use App\Http\Controllers\NotificationController;

Route::middleware('auth')->group(function () {
    Route::middleware('account')->group(function () {
        Route::middleware('role:owner,family_member')->group(function () {
            Route::post('invite', [InvitationController::class, 'sendInvitation']);
        });

        Route::middleware('role:family_member,guest')->group(function () {
            Route::get('markHome', [HomeController::class, 'markHome']);
            Route::get('markNotHome', [HomeController::class, 'markNotHome']);
        });
        
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
Route::get('sendNotification', [NotificationController::class, 'sendNotification']);