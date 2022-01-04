<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Uptime;
use App\Http\Resources\UptimeResource;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class UptimeController extends Controller
{ 
    public function getYesterdayEnergyInfo()
    {
        $lampWatts = 9;
        $pricePerKwh = 0.14450;

        $yesterday = date("Y-m-d", strtotime( '-1 days' ) );
        //$uptimes = UptimeResource::collection(Uptime::all())->where('created_at', '>' , $yesterday);
        $uptimes = DB::table('uptimes')->whereDate('created_at', $yesterday)->get();
        
        $dateTime = Carbon::today();

        foreach($uptimes as $uptime){
            $time = Carbon::parse($uptime->time)->format('H:i:s');
            $timePieces = explode(":", $time);
            $dateTime = $dateTime->addHours((int)$timePieces[0]);
            $dateTime = $dateTime->addMinutes((int)$timePieces[1]);
            $dateTime = $dateTime->addSeconds((int)$timePieces[2]);  
        }
        $totalTime = $dateTime->toTimeString();

        $totalTimePieces = explode(":", $totalTime);

        $hours = (int)$totalTimePieces[0];
        $minutes = (int)$totalTimePieces[1];
        $seconds = (int)$totalTimePieces[2];

        $dblHours = $hours + $minutes / 60 + $seconds / 3600;

        $kw = $lampWatts * $dblHours;
        $kwh = $kw / 1000;
        $priceInEur = $pricePerKwh * $kwh; 

        $response = [
            'totalTime' => $totalTime,
            'priceInEuros' => $priceInEur
        ];

        //obter euros num dia -> gasto
        //obter o tempo em horas minutos e segundos -> tempo 

        return response($response, 200);
    }


    public function getTotalUptimeById($id)
    {

        $yesterday = Carbon::yesterday();
        $uptimes = UptimeResource::collection(Uptime::all())->where('lamp_id', $id);
        $dateTime = Carbon::today();

        foreach($uptimes as $uptime){
            $time = Carbon::parse($uptime['time'])->format('H:i:s');
            $timePieces = explode(":", $time);
            $dateTime = $dateTime->addHours((int)$timePieces[0]);
            $dateTime = $dateTime->addMinutes((int)$timePieces[1]);
            $dateTime = $dateTime->addSeconds((int)$timePieces[2]);  
        }
        $totalTime = $dateTime->toTimeString();

        // $totalTimePieces = explode(":", $totalTime);

        // $hours = (int)$totalTimePieces[0];
        // $minutes = (int)$totalTimePieces[1];
        // $seconds = (int)$totalTimePieces[2];

        $response = [
            'totalTime' => $totalTime
        ];

        return response($response, 200);
    }
} 
