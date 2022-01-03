<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\UpstateResource;
use App\Models\Upstate;
use Carbon\Carbon;

class UpstateController extends Controller
{  
    public function getLastUpstateOfYesterday($id)
    {
        $lastUpstate = UpstateResource::collection(Upstate::all())->where('lamp_id', $id)->first();
        $time = Carbon::parse($lastUpstate['created_at'])->format('H:i');

        $response = [
            "lamp_id" => $lastUpstate['lamp_id'],
            "time" => $time
        ];

        return response($response, 200);
    }
} 

