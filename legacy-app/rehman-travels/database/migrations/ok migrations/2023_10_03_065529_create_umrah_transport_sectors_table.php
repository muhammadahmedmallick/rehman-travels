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
        Schema::create('umrah_transport_sectors', function (Blueprint $table) {
            $table->id();
            $table->string('sectorName',255);
            $table->string('sectorMarkup',255);
            $table->enum('sectorStatus',['0','1']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_transport_sectors');
    }
};
