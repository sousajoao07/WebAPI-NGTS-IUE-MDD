//
//  Room.swift
//  SmartRoom
//
//  Created by João Sousa on 18/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import Foundation

struct Room: Decodable, Equatable{
    var id : Int
    var state : Bool
    var name : String?
    
    static func ==(lhs: Room, rhs: Room) -> Bool{
        return lhs.id == rhs.id
    }
}
