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
            'knock_pattern_changed_at' => now(),
            'passcode' => '123456',
            'passcode_changed_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
