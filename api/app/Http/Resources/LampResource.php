<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class LampResource extends JsonResource
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
            'bulb_id'=> $this->bulb_id,
            'ip'=>$this->ip,  
            'name'=>$this->name, 
            'state'=>$this->state,
            'mac_address'=>$this->mac_address,
            'creared_at'=>$this->created_at,
            'updated_at'=>$this->updated_at
    ];    }
}
