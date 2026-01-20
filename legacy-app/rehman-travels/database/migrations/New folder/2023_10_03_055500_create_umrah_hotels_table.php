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
        Schema::create('umrah_hotels', function (Blueprint $table) {
            $table->id();
            $table->foreignId('createdById')->constrained('users')->unsigned();
           $table->enum('createdByType',['user', 'agent', 'owner', 'subagent']);
//            $table->foreignId('updatedById')->unsigned();
//            $table->enum('updatedByType',['user', 'agent', 'owner', 'subagent']);
            $table->string('hotelName',255);
            $table->string('vendorName',255);
            $table->enum('hotelLocation',['Makkah','Madinah','Jeddah']);
            $table->string('hotelDistance',25);
            $table->enum('basisType',['RO','BB','HB','FB']);
            $table->enum('hotelType',[1,2,3,4,5,6,7]);
            $table->string('hotelDesc',1000);
            $table->string('markup',25)->default(0);
            $table->enum('hotelStatus',[0,1]);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('umrah_hotels');
    }
};
