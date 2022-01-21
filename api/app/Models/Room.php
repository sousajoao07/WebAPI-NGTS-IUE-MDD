<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\Lamp;

class Room extends Model
{
    use HasFactory;

    protected $fillable = [
        'state',
        'name'
    ];

    public function lamps(){
        return $this->hasMany('App\Models\Lamp');
    }
}
