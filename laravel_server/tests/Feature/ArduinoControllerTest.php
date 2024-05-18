<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\Arduino;

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
}
