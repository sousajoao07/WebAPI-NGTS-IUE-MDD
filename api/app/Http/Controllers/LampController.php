<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Lamp;
use App\Models\Uptime;
use App\Models\Upstate;
use App\Http\Resources\LampResource;
use Illuminate\Support\Facades\Validator;
use Hhxsv5\SSE\SSE;
use Hhxsv5\SSE\Event;
use Hhxsv5\SSE\StopSSEException;
use Carbon\Carbon;

class LampController extends Controller
{
    //passos para criar:
    //app yeelight criar a lampada, obter o ip manualmente
    //criar lampada inserindo esse ip
    //evento despuletado no rasp para ele conhecer a lampada
    public function create(Request $request)
    {
        $fields = $request->validate([
                'ip' => 'required|string',
            ]);

        if (isset($fields['bulb_id'])) {
            $lamp = Lamp::updateOrCreate(
                ['bulb_id' =>  $fields['bulb_id']],
                ['ip' => $fields['ip']]
            );
        } else {
            $lamp = Lamp::create(['ip' => $fields['ip']]);
        }

        $response = [
            'lamp' => $lamp,
        ];

        return response($response, 201);
    }

    public function delete(Request $request, $id){
        $lamp = Lamp::findOrFail($id);
        $lamp->delete();

        return response(null, 204);
    }

    public function update(Request $request, $id){
        $fields = $request->validate([
            'name' => 'required|string',
            'state' => 'required|boolean',
            'mac_address' => 'required|string',
            'ip'=> 'required|string',
            'bulb_id'=> 'required|string'
        ]);

        $lamp = Lamp::findOrFail($id)->fill($fields);
        $lamp->save();

        return response($lamp, 202);
    }

    // public function changeState($id, $state){
    //     if($state=="true" || $state=="false"){
    //         $lamp = Lamp::findOrFail($id);
    //         $lamp->state = $state;
    //         $lamp->save();
    //     }
    //     else{
    //         return response(null, 400);
    //     }

    //     return response($lamp, 200);
    // }

    public function changeStateByID($id){

        if($id == null || $id == ""){
            return response(null, 400);
        }
        $lamp = Lamp::findOrFail($id);

        $lastUpState = $lamp->last_up_state;
        $currentTime = Carbon::now();

        if($lamp->state == true){
            $lamp->state = false;
            $t1 = Carbon::parse($lastUpState);
            $t2 = Carbon::parse($currentTime);
            $difference = $t1->diff($t2);

            $diffInSeconds = $difference->s; //45
            $diffInMinutes = $difference->i; //23
            $diffInHours   = $difference->h; //8
            $diffInDays    = $difference->d; //21

            $stringTime = $diffInHours . ":" . $diffInMinutes . ":" . $diffInSeconds;
            Uptime::create(['lamp_id' =>  $id, 'time' => $stringTime]);
        }else{
            $lamp->state = true;
            Upstate::create(['lamp_id' => $id]);
            $lamp->last_up_state = $currentTime;
        }

        $lamp->save();
        return response($lamp, 200);
    }

    public function changeStateForAll(){

        $arrayLamps = LampResource::collection(Lamp::all());
        $state = null;



        foreach ($arrayLamps as $lamp){
            if($lamp['state'] == true){
                $state = true; // estado geral, basta uma lamp ter luz ligada
            }
        }
        if($state == true){
            foreach($arrayLamps as $lamp){
                if($lamp['state'] == $state){ // Significa que esta luz está a fazer com que a sala esteja com o estado de luz ligada

                    $currentTime = Carbon::now();
                    $lastUpState = $lamp['last_up_state'];
                    $lamp['state'] = false;
                    $lamp->save();

                    $t1 = Carbon::parse($lastUpState);
                    $t2 = Carbon::parse($currentTime);
                    $difference = $t1->diff($t2);

                    $diffInSeconds = $difference->s; //45
                    $diffInMinutes = $difference->i; //23
                    $diffInHours   = $difference->h; //8
                    $diffInDays    = $difference->d; //21

                    $stringTime = $diffInHours . ":" . $diffInMinutes . ":" . $diffInSeconds;
                    Uptime::create(['lamp_id' =>  $lamp['id'], 'time' => $stringTime]);
                }
            }
        } else {
            foreach($arrayLamps as $lamp){
                $currentTime = Carbon::now();
                $lamp['state'] = true;
                $lamp['last_up_state'] = $currentTime;
                $lamp->save();
                Upstate::create(['lamp_id' => $lamp['id']]);
            }
        }

        return response($arrayLamps, 200);
    }

    public function getLampById($id){
        return new LampResource(Lamp::find($id));
    }

    public function getLamps(){
        return response(LampResource::collection(Lamp::all()));
    }

    public function postIp(Request $request, $id)
    {
        $fields = $request->validate([
            'ip' => 'required|string']
        );

        $lamp = Lamp::findOrFail($id);
        if($lamp) {
            $lamp->ip = $fields['ip'];
            $lamp->save();
        }
        else{
            response(null, 400);
        }

        return response(null, 200);
    }


}
