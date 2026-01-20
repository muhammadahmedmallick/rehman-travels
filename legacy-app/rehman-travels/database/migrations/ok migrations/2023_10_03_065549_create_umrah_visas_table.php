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
        Schema::create('umrah_visas', function (Blueprint $table) {
            $table->id();
            $table->string('umrahVisaName',255);
            $table->date('umrahVisaPeriodFrom');
            $table->date('umrahVisaPeriodTo');
            $table->float('umrahVisaPrice', 8, 2);
            $table->enum('umrahVisaNationality',['Pakistan', 'Others']);
            $table->enum('umrahVisaPriceStatus',['0','1']);
            $table->timestamps();
        });
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_visas');
    }
};
