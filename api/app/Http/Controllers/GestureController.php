<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Gesture;
use App\Http\Resources\GestureResource;
use Illuminate\Support\Facades\Validator;

class GestureController extends Controller
{
    public function create(Request $request){
        $fields = $request->validate([
            'name'=>'required|string',
            'action'=>'required|in:ligar,desligar,diminuiluz,aumentaluz,avancacor,recuacor,comecadisco',
        ]);

        $gesture = Gesture::create([
            'name' => $fields['name'],
            'action'=> $fields['action']
        ]);

        $response = [
            'gesture' => $gesture,
        ];

        return response($response, 201);
    }

    public function updateGestureAction(Request $request, $id){
        $request->validate([
            'action'=>'required|in:ligar,desligar,diminuiluz,aumentaluz,avancacor,recuacor,comecadisco',
        ]);

        $gesture = Gesture::findOrFail($id)->fill($request->all());
        $gesture->save();
        
        return response($gesture, 202);
    }

    public function getActionByGestureName($name){
        $gesture = Gesture::where('name', $name)->first();

        $response = [
            'action' => $gesture['action']
        ];
        
        return response($response, 200);
    }

    public function getGestures(){
        $gestures = Gesture::orderBy('id', 'ASC')->get();
        return json_encode(GestureResource::collection($gestures));
    }

    public function updateGestureActionById(Request $request, $id){
        $fields = $request->validate([
            'action' => 'required|string']
        );

        $gesture = Gesture::findOrFail($id);
        if($gesture) {
            $gesture->action = $fields['action'];
            $gesture->save();
        }
        else{
            response(null, 400);
        }

        return response(null, 200);
    }
    
}
