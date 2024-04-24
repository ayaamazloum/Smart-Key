<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('invitations', function (Blueprint $table) {
            $table->id();
            $table->string('email');
            $table->foreignId('arduino_id')->constrained()->onDelete('cascade');
            $table->timestamps();
        });
        Schema::create('commands', function (Blueprint $table) {
            $table->id();
            $table->string('command');
            $table->foreignId('arduino_id')->constrained()->onDelete('cascade');
            $table->timestamps();
        });
        Schema::create('logs', function (Blueprint $table) {
            $table->id();
            $table->text('log');
            $table->foreignId('arduino_id')->constrained()->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('invitations');
        Schema::dropIfExists('commands');
        Schema::dropIfExists('logs');
    }
};
