//
//  Google+Keychain.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

import Foundation

extension Google {
    @globalActor
    actor SessionKeychainStore {
        static let shared = SessionKeychainStore()
        
        static let securityAttributeCreator           = "jtem".fourCharUInt32! /*Jet Email*/
        static let securityAttributeTypeGoogleAccount = "GGac".fourCharUInt32! /*Google Acccount*/
        
        typealias Item = (id: Google.Account.ID, gtm: Google.GTMAuthSession, keychain: SecKeychainItem)
         
        func insertItem(id: Google.Account.ID, username: String, gtm gtmSession: Google.GTMAuthSession) throws -> Item {
            if let item = try item(id: id) { item }
            else if let item = try addItem(id: id, username: username, gtm: gtmSession) { item }
            else { throw Google.AuthError.sessionStoreAddFail }
        }
        
        func addItem(id: Google.Account.ID, username: String, gtm gtmSession: Google.GTMAuthSession) throws -> Item? {
            SessionKeychainStore.assertIsolated()
            let attributes = [
                
                /* class */
                kSecClass                    : kSecClassGenericPassword as String,
                
                /* attributes */
                kSecAttrService              : "me.frogcjn.jet-email.account.google",      // mark location: Jet Email - Account - Google
                kSecAttrCreator              : Self.securityAttributeCreator,              // mark creator: Jet Email
                kSecAttrType                 : Self.securityAttributeTypeGoogleAccount,    // mark a data type: Google Account
                kSecAttrAccount              : id.string,                                  // unique id under location and type
                
                kSecAttrLabel                : "Jet Email - Google Account: \(username)",  // label
                
                /* protection attributes*/
                kSecAttrAccessible           : kSecAttrAccessibleAfterFirstUnlock,
                // kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (not migrate or recover from backup)
                // kSecAttrAccessGroup          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
                // if kSecAttrAccessGroup set, kSecUseDataProtectionKeychain or kSecAttrSynchronizable must be true
                // kSecUseDataProtectionKeychain: true,
                // kSecAttrSynchronizable       : false,
                
                /* value */
                kSecValueData                : try gtmSession.data,
                //kSecReturnAttributes         : true,
                kSecReturnRef                : true,
                //kSecReturnPersistentRef      : true
            ] as [String : Any]
            
            var value: CFTypeRef?
            let resultCode = SecItemAdd(attributes as CFDictionary, &value)
            switch resultCode {
            case errSecSuccess:
                let keychainItem = value as! SecKeychainItem
                return (id, gtmSession, keychainItem)
            case errSecDuplicateItem:
                return nil
            default: fatalError()
            }
        }
        
        
        func deleteItem(_ item: Item) throws -> Item {
            SessionKeychainStore.assertIsolated()
            let query = [
                kSecValuePersistentRef: item.keychain
            ] as [String : Any]
            let resultCode = SecItemDelete(query as CFDictionary)
            assert(resultCode == errSecSuccess)
            return item
        }
        
        func item(id: Google.Account.ID) throws -> Item? {
            SessionKeychainStore.assertIsolated()
            
            let query =  [
                
                /* class */
                kSecClass                    : kSecClassGenericPassword,
                
                /* attributes */
                kSecAttrService              : "me.frogcjn.jet-email.account.google",       // mark location: Jet Email - Account - Google
                kSecAttrCreator              : Self.securityAttributeCreator,           // mark creator: Jet Email
                kSecAttrType                 : Self.securityAttributeTypeGoogleAccount, // mark this keychain type: Google Account
                kSecAttrAccount              : id.string, // account
                // kSecAttrLabel                : "Jet Email - Google Account: \(name)", // name
                
                /* protection attributes*/
                kSecAttrAccessible           : kSecAttrAccessibleAfterFirstUnlock,
                // kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (not migrate or recover from backup)
                // kSecAttrAccessGroup          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
                // if kSecAttrAccessGroup set, kSecUseDataProtectionKeychain or kSecAttrSynchronizable must be true
                // kSecUseDataProtectionKeychain: true,
                // kSecAttrSynchronizable       : false,
                
                kSecMatchLimit               : kSecMatchLimitOne,
                
                /* return type */
                kSecReturnData               : true, // cannot use with kSecMatchLimitAll
                // kSecReturnAttributes         : true,
                kSecReturnRef                : true,
                // kSecReturnPersistentRef      : true
            ] as [String: Any]
            
            var value: CFTypeRef?
            let resultCode = SecItemCopyMatching(query as CFDictionary, &value)
            switch resultCode {
            case errSecSuccess:
                let attributes   = value as! [CFString: Any]
                let keychainItem = attributes[kSecValueRef] as! SecKeychainItem
                let gtmSession   = try (attributes[kSecValueData] as! Data).gtmSession
                return (id, gtmSession, keychainItem)
            case errSecItemNotFound:
                return nil
            default: fatalError()
            }
            
        }
        
        func items() throws -> [Item] {
            SessionKeychainStore.assertIsolated()
            let query =  [
                /* class */
                kSecClass                    : kSecClassGenericPassword,
                
                /* attributes */
                kSecAttrService              : "me.frogcjn.jet-email.account.google", // location
                kSecAttrCreator              : Self.securityAttributeCreator, // mark creator
                kSecAttrType                 : Self.securityAttributeTypeGoogleAccount, // mark type
                // kSecAttrAccount              : "118079304514516479465", // account
                // kSecAttrLabel                : "Jet Email - Google Account: williamfrog@gmail.com", // name

                /* protection attributes */
                kSecAttrAccessible           : kSecAttrAccessibleAfterFirstUnlock,
                // kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (not migrate or recover from backup)
                // kSecAttrAccessGroup          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
                // if kSecAttrAccessGroup set, kSecUseDataProtectionKeychain or kSecAttrSynchronizable must be true
                // kSecUseDataProtectionKeychain: true,
                // kSecAttrSynchronizable       : false,
                // kSecUseAuthenticationContext       : "Authenticate to retrieve your secret!"

                kSecMatchLimit               : kSecMatchLimitAll,
                
                /* return type */
                // kSecReturnData               : true, cannot use with kSecMatchLimitAll
                kSecReturnAttributes         : true,
                kSecReturnRef                : true,
                kSecReturnPersistentRef      : true
            ] as [String: Any]
            // errSecParam
            var value: CFTypeRef?
            let resultCode = SecItemCopyMatching(query as CFDictionary, &value)
            switch resultCode {
            case errSecItemNotFound:
                return []
            case errSecSuccess:
                let attriutesList = value as! [[CFString: Any]]
                let items: [Item] = try attriutesList.map { attributes in
                    
                    let id = attributes[kSecAttrAccount] as! String
                    let keychainItem = attributes[kSecValueRef] as! SecKeychainItem
                    let query: [String: Any] = [
                        kSecValueRef  : keychainItem,
                        kSecReturnData: true,
                    ] as [String: Any]
                    
                    var value: CFTypeRef?
                    let resultCode = SecItemCopyMatching(query as CFDictionary, &value)
                    assert(resultCode == errSecSuccess)
                    let gtmSession = try (value as! Data).gtmSession
                    
                    return (.init(string: id), gtmSession, keychainItem)
                }
                return items
                
            default: fatalError()
            }
        }
        
        func updateItem(_ item: Item) throws -> Item {
            BackgroundActor.assertIsolated()
            let query = [
                kSecValuePersistentRef: item.keychain
            ] as [String : Any]
            let attributesToUpdate = [
                
                /* class */
                //kSecClass                    : kSecClassGenericPassword as String,
                
                /* attributes */
                //kSecAttrService              : "me.frogcjn.jet-email.account.google",      // mark location: Jet Email - Account - Google
                //kSecAttrCreator              : Self.securityAttributeCreator,              // mark creator: Jet Email
                //kSecAttrType                 : Self.securityAttributeTypeGoogleAccount,    // mark a data type: Google Account
                kSecAttrAccount              : item.id,                                         // unique id under location and type
                
                //kSecAttrLabel                : "Jet Email - Google Account: \(item.username)",  // label
                
                /* protection attributes*/
                //kSecAttrAccessible           : kSecAttrAccessibleAfterFirstUnlock,
                // kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (not migrate or recover from backup)
                // kSecAttrAccessGroup          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
                // if kSecAttrAccessGroup set, kSecUseDataProtectionKeychain or kSecAttrSynchronizable must be true
                // kSecUseDataProtectionKeychain: true,
                // kSecAttrSynchronizable       : false,
                
                /* value */
                kSecValueData                : try item.gtm.data,
                //kSecReturnAttributes         : true,
                //kSecReturnRef                : true,
                //kSecReturnPersistentRef      : true
            ] as [String : Any]
            
            let resultCode = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            assert(resultCode == errSecSuccess)
            return item
        }
        
    }
}

fileprivate extension Google.GTMAuthSession {
    var data: Data {
        get throws {
            let keyedArchiver = NSKeyedArchiver(requiringSecureCoding: true)
            keyedArchiver.encode(self, forKey: NSKeyedArchiveRootObjectKey)
            keyedArchiver.finishEncoding()
            return keyedArchiver.encodedData
        }
    }
}

fileprivate extension Data {
    var gtmSession: Google.GTMAuthSession {
        get throws {
            let keyedUnarchiver = try NSKeyedUnarchiver(forReadingFrom: self)
            keyedUnarchiver.requiresSecureCoding = true
            //keyedUnarchiver.setClass(AuthSession.self, forClassName: "GTMAppAuthFetcherAuthorization")

            guard let authSession = keyedUnarchiver.decodeObject(of: Google.GTMAuthSession.self, forKey: NSKeyedArchiveRootObjectKey) else {
                throw Google.AuthError.decodeFromKeychainError
            }
            return authSession
        }
    }
}
