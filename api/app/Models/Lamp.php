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
        'mac_address',
        'ip',
        'bulb_id'
    ];
}