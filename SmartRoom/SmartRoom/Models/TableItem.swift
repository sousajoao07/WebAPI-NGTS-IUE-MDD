//
//  TableItem.swift
//  Login
//
//  Created by João Sousa on 22/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit
enum TabItem: String, CaseIterable {
    case calls = "calls"
    case photos = "photos"
    case contacts = "friends"
    case messages = "messages"
    var viewController: UIViewController {
        switch self {
        case .calls:
            return CallsViewController()
            
        case .contacts:
            return ContactsViewController()
        case .photos:
            return PhotosViewController()
        case .messages:
            return InboxViewController()
        }
    }
    // these can be your icons
    var icon: UIImage {
        switch self {
        case .calls:
            return UIImage(named: "ic_phone")!
            
        case .photos:
            return UIImage(named: "ic_camera")!
        case .contacts:
            return UIImage(named: "ic_contacts")!
        case .messages:
            return UIImage(named: "ic_message")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
