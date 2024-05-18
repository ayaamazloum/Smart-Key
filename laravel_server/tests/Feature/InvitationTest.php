<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\User;
use App\Models\Invitation;

class InvitationTest extends TestCase
{
        /** @test */
    public function test_send_invitation()
    {
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);

        $invitationData = [
            'email' => 'example@example.com',
            'type' => 'family_member',
        ];

        $response = $this->actingAs($user)->postJson('/api/invite', $invitationData);

        $response->assertStatus(200)->assertJson([
            'status' => 'success',
        ]);

        $this->assertDatabaseHas('invitations', [
            'email' => 'example@example.com',
        ]);
    }

    public function test_get_all_invitations()
    {
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);        

        $this->actingAs($user);

        $invitations = Invitation::factory()->count(3)->create(['arduino_id' => $user->arduino_id]);

        $response = $this->getJson('/api/invitations');

        $response->assertStatus(200)
                 ->assertJsonStructure([
                     'invitations' => [
                        '*' => [
                            'id',
                            'email',
                            'type',
                            'key',
                            'arduino_id',
                            'start_date',
                            'end_date',
                            'created_at',
                            'updated_at'
                        ]
                     ],
                 ]);
    }

    public function test_delete_invitation()
    {
        $user = User::factory()->create([
            'name' => 'Test User',
            'arduino_id' => 1,
            'role_id' => 1,
        ]);

        $invitation = Invitation::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/deleteInvitation', ['id' => $invitation->id]);

        $response->assertStatus(200)->assertJson([
            'status' => 'success',
        ]);

        $this->assertDatabaseMissing('invitations', [
            'id' => $invitation->id,
        ]);
    }
}
