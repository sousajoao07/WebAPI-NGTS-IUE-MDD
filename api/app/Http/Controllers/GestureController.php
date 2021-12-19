<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use App\Models\Gesture;
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
        
        return response($lamp, 202);
    }

    public function getActionByGestureName($name){
        $gesture = Gesture::where('name', $name)->first();

        $response = [
            'action' => $gesture['action']
        ];
        
        return response($response, 200);
    }

    
}