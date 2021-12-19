<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateGesturesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('gestures', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->enum('action', [
                'turn_on',
                'turn_off',
                'increase_light',
                'decrease_light',
                'next_color',
                'previous_color',
                'disco_flow'
            ]);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('gestures');
    }
}
