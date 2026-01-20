<?php

use Illuminate\Database\Migrations\Migration;
use App\Models\SiteContent\ContentPage;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cms_visa_durations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('periodId')->constrained('content_pages')->unsigned();
            $table->string('visaTitle', 255);
            $table->string('visaPrice', 45);
            $table->integer('currencyId');
            $table->integer('numEntries');
            $table->string('duration', 45);
            $table->string('validity', 45);
            $table->string('validForCityId', 45);
            $table->integer('visaType');
            $table->longText('visaIncludes');
            $table->date('createDate');
            $table->tinyInteger('durationStatus');
            $table->timestamps();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_visa_durations');
    }
};
