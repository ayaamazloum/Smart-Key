<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\InvitationController;

Route::middleware('auth')->group(function () {
    Route::middleware('account')->group(function () {
        Route::middleware('role:owner,family_member')->group(function () {
            Route::post('invite', [InvitationController::class, 'sendInvitation']);
        });

        Route::get('logout', [AuthController::class, 'logout']);
        Route::get('refresh', [AuthController::class, 'refresh']);
    });
});

Route::middleware('arduino')->group(function () {
    Route::get('knockPattern', [ArduinoController::class, 'getKnockPattern']);
});

Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
