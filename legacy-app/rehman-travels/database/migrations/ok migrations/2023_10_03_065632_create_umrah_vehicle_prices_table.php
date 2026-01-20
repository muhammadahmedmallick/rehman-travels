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
        Schema::create('umrah_vehicle_prices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vehicleId')->constrained('umrah_vehicles')->unsigned();
            $table->foreignId('sectorId')->constrained('umrah_transport_sectors')->unsigned();
            $table->float('vehiclePrice', 8, 2);
            $table->enum('vehiclePriceStatus',['0','1']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_vehicle_prices');
    }
};
