<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ArduinoController extends Controller
{
    public function __construct()
    {
        $this->middleware('arduino');
    }

    public function test()
    {
        return response()->json(['status' => 'success']);
    }
}
