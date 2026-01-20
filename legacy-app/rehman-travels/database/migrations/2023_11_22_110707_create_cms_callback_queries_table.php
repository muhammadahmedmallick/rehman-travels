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
        Schema::create('cms_callback_queries', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('customerId')->unsigned();
            $table->text('message');
            $table->string('leadFrom', 55);
            $table->string('sectors', 255)->nullable();
            $table->enum('moduleId', ['1', '2', '3', '4', '5', '6', '7', '8'])->comment('1=Umrah,2=Hajj,3=Visa,4=PkTour,5=Contactus,6=Franchise,7=Airline,8=CarBranding');
            $table->string('domIntl', 20)->nullable();
            $table->string('airlineCode', 5)->nullable();
            $table->string('country', 15)->nullable();
            $table->string('clientIp', 20)->nullable()->comment("Visitor IP Address");
            $table->string('clientBrowser', 254)->nullable()->comment("Visitor Browser Information");
            $table->string('clientPlatform', 254)->nullable()->comment("Visitor Operating System Information");
            $table->enum('ismobile', ['1','2'])->nullable()->comment("1=Mobile,2=Not Mobile");
            $table->string('mobileInfo', 254)->nullable()->comment("Visitor device");
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cms_callback_queries');
    }
};
