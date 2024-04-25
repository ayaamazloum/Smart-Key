<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ArduinoController;

Route::middleware('jwt.auth')->group(function () {
    Route::middleware('role:Owner')->group(function () {
    });
    Route::post('logout', [UserController::class, 'logout']);
});

Route::get('test', [ArduinoController::class, 'test']);
