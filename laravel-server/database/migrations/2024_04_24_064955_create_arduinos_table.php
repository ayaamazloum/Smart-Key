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
        Schema::create('arduinos', function (Blueprint $table) {
            $table->id();
            $table->string('key');
            $table->string('knock_pattern');
            $table->string('knock_pattern_changed_at');
            $table->string('passcode');
            $table->string('passcode_changed_at');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('arduinos');
    }
};
