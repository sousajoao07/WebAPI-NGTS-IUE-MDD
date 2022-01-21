//  Constants.swift
//  SmartRoom
//
//  Created by João Sousa on 27/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Api {
        
        static let IP = "localhost"
        static let URL = "http://\(IP):8080/api"
        static let SYNC = "\(URL)/sync/ios"
    }
    
    struct Storyboard{
        
        static let lampsViewController = "MainTabBarController"
        static let loginNavigationController = "LoginNavigationController"
    }
    
}
    
    
