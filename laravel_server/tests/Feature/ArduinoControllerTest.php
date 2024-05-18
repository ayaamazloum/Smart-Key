<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\Arduino;
use App\Models\User;

class ArduinoControllerTest extends TestCase
{
    public function test_get_knock_pattern()
    {
        $arduino = Arduino::findOrFail(1);

        $response = $this->withHeaders(['Authorization' => 'Bearer ' . $arduino->key])
            ->getJson('/api/knockPattern');

        $response->assertStatus(200)
            ->assertJson([
                'status' => 'success',
                'knockPattern' => $arduino->knock_pattern,
            ]);
    }

    public function test_arduino_log()
    {
        $arduino = Arduino::findOrFail(1);

        $logData = ['log' => 'Test Log'];

        $response = $this->withHeaders(['Authorization' => 'Bearer ' . $arduino->key])
            ->postJson('/api/arduinoLog', $logData);

        $response->assertStatus(200)
            ->assertJson([
                'status' => 'success',
                'message' => 'Log added successfully.',
            ]);

        $this->assertDatabaseHas('logs', [
            'log' => 'Test Log',
            'arduino_id' => $arduino->id,
        ]);
    }

    public function testChangePasscode()
    {
        $arduino = Arduino::findOrFail(1);
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);

        $response = $this->actingAs($user)->postJson('/api/changePasscode', [
            'currentPasscode' => $arduino->passcode,
            'newPasscode' => 'newpasscode123',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'status' => 'success',
                'message' => 'Passcode changed successfully.',
            ]);
        
        $this->assertDatabaseHas('arduinos', ['id' => $arduino->id, 'passcode' => 'newpasscode123']);
    }

    public function testGetKnock()
    {
        $arduino = Arduino::findOrFail(1);
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);
        
        $response = $this->withHeaders(['Authorization' => 'Bearer ' . $arduino->key])
        ->getJson('/api/knockPattern');

        $response->assertStatus(200)
            ->assertJsonStructure([
                'status',
                'knockPattern',
            ]);
    }

    public function testChangeKnock()
    {
        $arduino = Arduino::findOrFail(1);
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);

        $response = $this->actingAs($user)->postJson('/api/changeKnock', [
            'newPattern' => '1101101',
        ]);

        $response->assertStatus(200)
            ->assertJson([
                'status' => 'success',
                'message' => 'Knock changed successfully.',
            ]);
        
        $this->assertDatabaseHas('arduinos', ['id' => $arduino->id, 'knock_pattern' => '1101101']);
    }
}
