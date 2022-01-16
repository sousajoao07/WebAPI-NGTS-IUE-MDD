<?php

namespace App\Http\Controllers;

use App\Models\Lamp;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Hhxsv5\SSE\SSE;
use Hhxsv5\SSE\Event;
use Hhxsv5\SSE\StopSSEException;

class SyncController extends Controller
{
    public function gestures()
    {
        $response = $this->newStreamedResponse();

        $response->setCallback(function () {
            $lastUpdate = null;

            $callback = function () use (&$lastUpdate) {
                $gestures = DB::table('gestures')->when($lastUpdate, function ($query, $lastUpdate) {
                    return $query->whereDate('updated_at', '>=', $lastUpdate->toDateString())
                        ->whereTime('updated_at', '>', $lastUpdate->toTimeString());
                })->get();

                if (empty($gestures) ) {
                    return false;
                }

                $shouldStop = false;
                if ($shouldStop) {
                    throw new StopSSEException();
                }

                $lastUpdate = Carbon::now();

                return json_encode($gestures);
            };
            (new SSE(new Event($callback)))->start();
        });
    
        return $response;
    }

    public function lamps()
    {
        $response = $this->newStreamedResponse();

        $response->setCallback(function () {
            $lastUpdate = null;

            $callback = function () use (&$lastUpdate) {
                $lamps = DB::table('lamps')->when($lastUpdate, function ($query, $lastUpdate){
                    return $query->whereDate('updated_at', '>=', $lastUpdate->toDateString())
                        ->whereTime('updated_at', '>', $lastUpdate->toTimeString());
                })->get();

                if (empty($lamps)) {
                    return json_encode([]);
                }

                $shouldStop = false;
                if ($shouldStop) {
                    throw new StopSSEException();
                }

                $lastUpdate = Carbon::now();

                return json_encode($lamps);
            };
            (new SSE(new Event($callback)))->start();
        });

        return $response;
    }

    private function newStreamedResponse()
    {
        $response = new \Symfony\Component\HttpFoundation\StreamedResponse();
        $response->headers->set('Content-Type', 'text/event-stream');
        $response->headers->set('Cache-Control', 'no-cache');
        $response->headers->set('Connection', 'keep-alive');
        $response->headers->set('X-Accel-Buffering', 'no');

        return $response;
    }
}
