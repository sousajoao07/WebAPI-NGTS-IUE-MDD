<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class UptimeResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id'=> $this->id,
            'lamp_id' => $this->lamp_id,
            'time'=> $this->time,
    ];    }
}
