<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Room;

class Lamp extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'state',
        'ip',
        'room_id',
        'bulb_id',
        'last_up_state'
    ];

    protected $casts = [
        'bulb_id' => 'string',
    ];

    public function room(){
        return $this->belongsTo('App\Models\Room');
    }
}
