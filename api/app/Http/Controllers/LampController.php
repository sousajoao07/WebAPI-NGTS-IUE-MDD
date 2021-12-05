<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Lamp;
use App\Http\Resources\LampResource;

class LampController extends Controller
{
    public function create(Request $request){
        $fields = $request->validate([
            'name' => 'required|string',
            'state' => 'required|boolean',
            'mac_address' => 'required|string',
        ]);

        $lamp = Lamp::create([
            'name' => $fields['name'],
            'state' => $fields['state'],
            'mac_address' => $fields['mac_address'],
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
        ]);

        $lamp = Lamp::findOrFail($id)->fill($fields);
        $lamp->save();
        $response = [
            'lamp' => $lamp,
        ];
        return response($lamp, 202);
    }

    public function changeState(Request $request){

    }

    public function getLampById($id){
        return new LampResource(Lamp::find($id));
    }

    public function getLamps(){
        return LampResource::collection(Lamp::all());
    }
}
