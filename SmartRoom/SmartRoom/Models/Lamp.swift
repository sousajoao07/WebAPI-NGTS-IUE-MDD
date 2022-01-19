//
//  Lamp.swift
//  Login
//
//  Created by João Sousa on 21/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//
import UIKit

struct Lamp: Decodable, Equatable{
    var id : Int
    var ip : String
    var name : String
    var roomId: Int
    var state : Bool
    
    static func ==(lhs: Lamp, rhs: Lamp) -> Bool{
        return lhs.id == rhs.id
    }
}
