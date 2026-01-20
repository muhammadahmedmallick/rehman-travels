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
        Schema::create('umrah_vehicles', function (Blueprint $table) {
            $table->id();
            $table->string('vehicleName',255);
            $table->string('vehicleMarkup',255);
            $table->enum('vehicleStatus',[0,1]);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_vehicles');
    }
};
