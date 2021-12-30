//
//  KeychainHelper.swift
//  SmartRoom
//
//  Created by João Sousa on 29/12/21.
//  Copyright © 2021 João Sousa. All rights reserved.
//

import UIKit
import Foundation

class Keychain {

    static func save(password: Data, service: String, account: String) throws {
        
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecValueData is the item value to save
            kSecValueData as String: password as AnyObject
        ]
        
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        // errSecDuplicateItem is a special case where the
        // item identified by the query already exists. Throw
        // duplicateItem so the client can determine whether
        // or not to handle this as an error
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        // Any status other than errSecSuccess indicates the
        // save operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

}
