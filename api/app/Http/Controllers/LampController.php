<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Lamp;
use App\Models\Room;
use App\Models\Uptime;
use App\Models\Upstate;
use App\Http\Resources\LampResource;
use App\Http\Resources\RoomResource;
use Illuminate\Support\Facades\Validator;
use Hhxsv5\SSE\SSE;
use Hhxsv5\SSE\Event;
use Hhxsv5\SSE\StopSSEException;
use Carbon\Carbon;
use Illuminate\Support\Str;

class LampController extends Controller
{
    public function create(Request $request)
    {
        $fields = $request->all();

        $lamp = Lamp::updateOrCreate(
            ['bulb_id' =>  $fields['id']],
            [
                'ip' => $fields['ip'],
                'state' => $fields['state'],
                'name' => 'Lamp ' . Str::random(2)
            ]
        );

        $response = [
            'lamp' => $lamp,
        ];

        return response($response, 201);
    }

    public function delete($id){
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

        $arrayLamps = LampResource::collection(Lamp::where('room_id', $lamp->room_id)->get());

        $count = 0;
        foreach($arrayLamps as $lamp){           
            if($lamp->state == true){
                $count ++;
            }
        }

        $room = Room::findOrFail($lamp->room_id);
        if($count == 0){
            $room->state = false;
        }else{          
            $room->state = true;
        }

        $room->save();

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
        return response(Lamp::orderBy('name', 'ASC')->select(['id', 'ip', 'state', 'name', 
        'room_id as roomId'])->get());

    }

    // public function postIp(Request $request, $id)
    // {
    //     $fields = $request->validate([
    //         'ip' => 'required|string']
    //     );

    //     $lamp = Lamp::findOrFail($id);
    //     if($lamp) {
    //         $lamp->ip = $fields['ip'];
    //         $lamp->save();
    //     }
    //     else{
    //         response(null, 400);
    //     }

    //     return response(null, 200);
    // }

    public function changeRoom($id, $roomId){
        $lamp = Lamp::findoOrFail($id);
        $lamp -> room_id = $roomId;

        return response(null, 200);
    }


}
