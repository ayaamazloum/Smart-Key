<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use App\Models\User;
use App\Models\Log;
use Tests\TestCase;

class LogsTest extends TestCase
{
    // use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);
        $this->actingAs($this->user);
    }

    /** @test */
    public function it_can_add_a_log_entry()
    {
        $response = $this->postJson('/api/log', ['log' => 'test log entry']);

        $response->assertStatus(200)
                 ->assertJson([
                     'status' => 'success',
                     'message' => 'Log added successfully.',
                 ]);

        $this->assertDatabaseHas('logs', [
            'log' => 'Test User test log entry',
            'arduino_id' => $this->user->arduino_id
        ]);
    }
}
