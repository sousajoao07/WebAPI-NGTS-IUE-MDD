<?php

namespace App\Http\Controllers;

use App\Models\Room;
use App\Models\Lamp;
use App\Models\Uptime;
use App\Models\Upstate;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;
use App\Http\Resources\RoomResource;
use App\Http\Resources\LampResource;
use Carbon\Carbon;

class RoomController extends Controller
{
    public function create(Request $request){
        if($request->name != "" || $request->name != null ){
            $room = Room::create(['state' => false, 'name' => $request->name]);

            $response = [
                'room' => $room
            ];
    
            return response($response, 201);
        }
       return response(null, 400);
    }
    
    public function delete($id){
        $room = Room::findOrFail($id);
        $room->delete();

        return response(null, 204);
    }

    public function getRooms(){
        return response(RoomResource::collection(Room::orderBy('id', 'ASC')->get()));
    }

    public function changeStateForAllInTheRoom(Request $request, $id){

        $arrayLamps = LampResource::collection(Lamp::where('room_id', $id)->get());
        $room = Room::findOrFail($id);

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

       
        if($room->state == true){
            $room->state = false;
            $room->save();
        }else{
            $room->state = true;
            $room->save();
        }

        return response($room, 200);
    }

}
