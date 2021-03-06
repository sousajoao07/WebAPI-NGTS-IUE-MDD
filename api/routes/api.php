<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LampController;
use App\Http\Controllers\RoomController;
use App\Http\Controllers\GestureController;
use App\Http\Controllers\UpstateController;
use App\Http\Controllers\UptimeController;
use App\Http\Controllers\SyncController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
//Route::group(['middleware' => ['auth:sanctum']], function () {
    
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/lamp', [LampController::class, 'create']);
    Route::delete('/lamp/{id}', [LampController::class, 'delete']);
    Route::put('/lamp/{id}', [LampController::class, 'update']);
    Route::get('/lamp/{id}', [LampController::class, 'getLampById']);
    Route::get('/lamps' , [LampController::class, 'getLamps']);
    Route::patch('/lamp/{id}/ip', [LampController::class, 'postIp']);
    //Route::patch('lamp/{id}/state/{state}', [LampController::class, 'changeState']);
    Route::post('/lamp/{id}/toggle', [LampController::class, 'changeStateByID']);
    Route::post('/lamp/toggleAll', [LampController::class, 'changeStateForAll']);
    Route::post('/lamp/{id}/room/{roomId}', [LampController::class, 'changeRoom']);


    Route::post('/gesture', [GestureController::class, 'create']);
    Route::get('/gesture/{name}', [GestureController::class, 'getActionByGestureName']); 
    Route::get('/gestures', [GestureController::class, 'getGestures']);
    Route::patch('/gesture/{id}/action', [GestureController::class, 'updateGestureActionById']);
    
    Route::post('/room', [RoomController::class, 'create']);
    Route::get('/rooms', [RoomController::class, 'getRooms']);
    Route::post('/room/toggle/{id}/{state}', [RoomController::class, 'changeStateForAllInTheRoom']);
    

    Route::get('/uptimes/lastDay', [UptimeController::class, 'getYesterdayEnergyInfo']); //DigitalTwin
    Route::get('/uptimes/totalUptime/{id}', [UptimeController::class, 'getTotalUptimeById']); //DigitalTwin

    Route::get('/sync/gestures', [SyncController::class, 'gestures']);
    Route::get('/sync/lamps', [SyncController::class, 'lamps']);
    Route::get('/sync/ios', [SyncController::class, 'ios']);
    

//});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});