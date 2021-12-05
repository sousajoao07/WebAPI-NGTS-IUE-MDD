<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LampController;

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
Route::group(['middleware' => ['auth:sanctum']], function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/lamp', [LampController::class, 'create']);
    Route::delete('/lamp/{id}', [LampController::class, 'delete']);
    Route::patch('/lamp/{id}', [LampController::class, 'update']);
    Route::get('lamp/{id}', [LampController::class, 'getLampById']);
    Route::get('lamps' , [LampController::class, 'getLamps']);
});

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});