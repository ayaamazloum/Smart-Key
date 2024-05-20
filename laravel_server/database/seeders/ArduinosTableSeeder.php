<?php

namespace Database\Seeders;

use App\Models\Arduino;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ArduinosTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Arduino::create([
            'key' => 'yqquWzNXmS5WHSpLf6KF',
            'knock_pattern' => '11011011',
            'passcode' => '123456',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
