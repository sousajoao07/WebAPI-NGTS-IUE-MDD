//
//  Gesture.swift
//  SmartRoom
//
//  Created by João Sousa on 14/01/22.
//  Copyright © 2022 João Sousa. All rights reserved.
//

import UIKit

struct Gesture: Decodable{
    var id: Int?
    var name: String?
    var action: Action?
}

enum Action: Decodable {
    
    case turn_on, turn_off, increase_light, decrease_ligh, next_color, previous_color, disco_flow
    case unknown(value: String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let action = try? container.decode(String.self)
        switch action {
        case "turn_on": self = .turn_on
        case "turn_off": self = .turn_off
        case "increase_light": self = .increase_light
        case "decrease_light": self = .decrease_ligh
        case "next_color": self = .next_color
        case "previous_color": self = .previous_color
        case "disco_flow": self = .disco_flow
        default:
            self = .unknown(value: action ?? "unknown")
        }
    }
}

