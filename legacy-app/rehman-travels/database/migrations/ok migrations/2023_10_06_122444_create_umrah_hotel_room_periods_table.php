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
        Schema::create('umrah_hotel_room_periods', function (Blueprint $table) {
            $table->id();
            $table->foreignId('hotelId')->constrained('umrah_hotels')->unsigned();
            $table->date('periodFrom');
            $table->date('periodTo');
            $table->enum('ashraType',['0','1']);
            $table->enum('periodStatus',['0','1']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_hotel_room_periods');
    }
};
