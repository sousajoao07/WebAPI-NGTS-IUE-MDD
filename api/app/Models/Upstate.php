<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Upstate extends Model
{
    use HasFactory;

    protected $fillable = [
        'id',
        'lamp_id',
    ];
}
