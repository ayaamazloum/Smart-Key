<?php

namespace Database\Seeders;

use App\Models\Arduino;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class ArduinosTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $randomKey = Str::random(20);

        Arduino::create([
            'key' => $randomKey,
            'knock_pattern' => '11011011',
            'passcode' => '123456',
            'home_latitude' => '33.950211',
            'home_longitude' => '36.104758',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
