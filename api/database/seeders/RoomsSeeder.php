<?php

namespace Database\Seeders;

use App\Models\Room;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class RoomsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Room::create([
                'name' => 'Sala',
                'state' => false,
        ]);

        Room::create([
            'name' => 'Quarto',
            'state' => false,
        ]);
    }
}
