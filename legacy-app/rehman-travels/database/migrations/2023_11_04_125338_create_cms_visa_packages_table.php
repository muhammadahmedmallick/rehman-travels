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
        Schema::create('cms_visa_packages', function (Blueprint $table) {
            $table->id();
            $table->integer('cmsContentId');
            $table->string('countryName', 255);
            $table->string('packageUrl', 255);
            $table->string('tourUrl', 255);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_visa_packages');
    }
};
