<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Lamp;
use App\Http\Resources\LampResource;
use Illuminate\Support\Facades\Validator;

class LampController extends Controller
{
    //passos para criar:
    //app yeelight criar a lampada, obter o ip manualmente
    //criar lampada inserindo esse ip
    //evento despuletado no rasp para ele conhecer a lampada

    public function create(Request $request){
        $fields = $request->validate([
            'ip'=>'required|string',
        ]);

        $lamp = Lamp::create([
            'state' => 'on',
            'ip'=> $fields['ip']
        ]);

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

    public function changeState($id, $state){
        if($state=="true" || $state=="false"){
            $lamp = Lamp::findOrFail($id);
            $lamp->state = $state;
            $lamp->save();
        }
        else{
            return response(null, 400);
        }

        return response($lamp, 200);
    }

    public function getLampById($id){
        return new LampResource(Lamp::find($id));
    }

    public function getLamps(){
        return LampResource::collection(Lamp::all());
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