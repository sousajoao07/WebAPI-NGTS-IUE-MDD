<?php

namespace App\Http\Controllers;

use App\Models\Room;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Hash;
use App\Http\Resources\RoomResource;

class RoomController extends Controller
{
    public function create(){
        $room = Room::create(['state' => 0]);

        $response = [
            'room' => $room,
        ];

        return response($response, 201);
    }

    public function getRooms(){
        return response(RoomResource::collection(Room::orderBy('id', 'ASC')->get()));
    }
}
