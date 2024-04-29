<?php

namespace Database\Seeders;

use App\Models\Role;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class RolesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Role::create([
            'role' => 'owner',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        Role::create([
            'role' => 'family_member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        Role::create([
            'role' => 'guest',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}
