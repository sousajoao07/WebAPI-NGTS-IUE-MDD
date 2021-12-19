<?php

namespace Database\Seeders;

use App\Models\Gesture;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class GestureSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Gesture::create([
                'name' => 'Up',
                'action' => 'turn_on',
        ]);

        Gesture::create([
            'name' => 'Down',
            'action' => 'turn_off',
        ]);
    
        Gesture::create([
            'name' => 'Right',
            'action' => 'increase_light',
        ]);

        Gesture::create([
            'name' => 'Left',
            'action' => 'decrease_light',
        ]);
        
        Gesture::create([
            'name' => 'Clockwise',
            'action' => 'next_color',
        ]);
        
        Gesture::create([
            'name' => 'AntiClockwise',
            'action' => 'previous_color',
        ]);
        
        Gesture::create([
            'name' => 'Wave',
            'action' => 'disco_flow',
        ]);
    }
}
