//
//  Keychain.swift
//  Course4FinalTask
//
//  Created by Vinogradov Alexey on 06/11/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

class KeyChain {
    
    static let instance = KeyChain()
    let serviceName: String =  "instagram"
    
    func keychainQuery(service: String, account: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = serviceName as AnyObject
        query[kSecAttrAccount as String] = service as AnyObject
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject
        }
        return query
    }
    
    // MARK: - TOKEN
    
    func saveToken(token: String) -> Bool {
        let tokenData = token.data(using: .utf8)
        var item = keychainQuery(service: serviceName)
        
        item[kSecValueData as String] = tokenData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    func deleteToken() -> Bool {
        let item = keychainQuery(service: serviceName)
        let status = SecItemDelete(item as CFDictionary)
        return status == noErr
    }
    
    func readToken() -> String? {
        var query = keychainQuery(service: serviceName)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject] else {
            return nil
        }
        
        guard let tokenData = item[kSecValueData as String] as? Data,
            let token = String(data: tokenData, encoding: .utf8) else { return nil }
        
        return token
    }
    
    // MARK: - ACCOUNT+PASSWORD
    
    func savePassword(account: String, password: String) -> Bool {
        let passwordData = password.data(using: .utf8)
        
        if readPassword(account: account) != nil {
            
            var attributesToUpdate = [String : AnyObject]()
            
            attributesToUpdate[kSecValueData as String] = passwordData as AnyObject
            
            let query = keychainQuery(service: serviceName, account: account)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            return status == noErr
        }
        
        var item = keychainQuery(service: serviceName, account: account)
        item[kSecValueData as String] = passwordData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    func readPassword(account: String?) -> String? {
        var query = keychainQuery(service: serviceName, account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
            let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else {
                return nil
        }
        
        return password
    }
    
    
    func readAccountAndPassword(account: String?) -> [String : String]? {
        var query = keychainQuery(service: serviceName, account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject] else {
            return nil
        }
        var passwordItems = [String : String]()
        
        guard let passwordData = item[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8) else { return nil }
        if let account = item[kSecAttrAccount as String] as? String {
            passwordItems[account] = password
        }
        
        return passwordItems
    }
}
