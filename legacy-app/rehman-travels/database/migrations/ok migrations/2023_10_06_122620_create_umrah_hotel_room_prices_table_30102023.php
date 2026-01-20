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
        Schema::create('umrah_hotel_room_prices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('periodId')->constrained('umrah_hotel_room_periods')->unsigned();
            $table->float('onDayPrice', 8, 2);
            $table->float('offDayPrice', 8, 2);
            $table->enum('roomType',['Double', 'Triple', 'Quad']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_hotel_room_prices');
    }
};
