<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\OwnerController;

Route::middleware('auth')->group(function () {
    Route::middleware('role:owner')->group(function () {
        Route::post('invite', [OwnerController::class, 'sendInvitation']);
    });

    Route::middleware('role:family_member')->group(function () {
        Route::post('invite', [OwnerController::class, 'sendInvitation']);
    });

    Route::get('logout', [AuthController::class, 'logout']);
    Route::get('refresh', [AuthController::class, 'refresh']);
});

Route::middleware('arduino')->group(function () {
    Route::get('knockPattern', [ArduinoController::class, 'getKnockPattern']);
});

Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
