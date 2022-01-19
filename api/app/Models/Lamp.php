<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lamp extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'state',
        'ip',
        'room_id',
        'mac_address',
        'bulb_id',
        'last_up_state'
    ];

    public function room(){
        return $this->belongsTo('App\Room');
    }
}
