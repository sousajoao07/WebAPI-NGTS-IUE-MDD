//
//  Lamp.swift
//  Login
//
//  Created by João Sousa on 21/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//
import UIKit

struct Lamp: Equatable{
    var id : Int
    var name : String
    var state : Bool
    var ip : String
    
    static func ==(lhs: Lamp, rhs: Lamp) -> Bool{
        return lhs.id == rhs.id
    }
}
