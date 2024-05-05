<?php

namespace Database\Seeders;

use App\Model\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class InvitationsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        User::create([
            'email' => 'ayamazloum1999@gmail.com',
            'type' => 'owner',
            'key' => '7Hz7XWsB',
            'arduino_id' => '1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
