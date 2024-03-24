//
//  Google+Keychain.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/20/24.
//

import Foundation
import JetEmailData

actor Keychain {
    static let shared = Keychain()
    static let securityAttributeCreator           = "jtem".fourCharUInt32! /*Jet Email*/
    static let securityAttributeTypeGoogleAccount = "GGac".fourCharUInt32! /*Google Acccount*/
    
    func insertItem(gtmSession: GTMSession) throws -> GoogleSessionItem {
        //SessionKeychain.assertIsolated()
        if let item = try item(id: try gtmSession.accountID) { item } // find item in keyChain
        else if let item = try addItem(gtmSession: gtmSession) { item } // if not find add item in keyChain
        else { throw AuthError.sessionStoreAddFail }
    }
    
    func addItem(gtmSession: GTMSession) throws -> GoogleSessionItem? {
        let (id, username) = try gtmSession.accountIDAndUsername
        //SessionKeychain.assertIsolated()
        let attributes = [
            
            /* class */
            kSecClass                    : kSecClassGenericPassword as String,
            
            /* attributes */
            kSecAttrService              : "me.frogcjn.jet-email.account.google",      // mark location: Jet Email - Account - Google
            kSecAttrCreator              : Self.securityAttributeCreator,              // mark creator: Jet Email
            kSecAttrType                 : Self.securityAttributeTypeGoogleAccount,    // mark a data type: Google Account
            kSecAttrAccount              : id.innerID,                                  // unique id under location and type
            kSecAttrGeneric              : try username.data,
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
            // kSecReturnRef                : true,
            kSecReturnPersistentRef      : true
        ] as [String : Any]
        
        var value: CFTypeRef?
        let resultCode = SecItemAdd(attributes as CFDictionary, &value)
        switch resultCode {
        case errSecSuccess:
            let keychainItem = value as! Data
            return .init(account: .init(id: id, username: username), gtmSession: gtmSession, keychainItem: keychainItem)
        case errSecDuplicateItem:
            return nil
        default: fatalError()
        }
    }
    
    
    func deleteItem(_ item: GoogleSessionItem) throws -> GoogleSessionItem {
        //SessionKeychain.assertIsolated()
        let query = [
            kSecValuePersistentRef: item.keychainItem
        ] as [String : Any]
        let resultCode = SecItemDelete(query as CFDictionary)
        assert(resultCode == errSecSuccess)
        return item
    }
    
    func item(id: GoogleAccountID) throws -> GoogleSessionItem? {
        //SessionKeychain.assertIsolated()
        
        let query =  [
            
            /* class */
            kSecClass                    : kSecClassGenericPassword,
            
            /* attributes */
            kSecAttrService              : "me.frogcjn.jet-email.account.google",       // mark location: Jet Email - Account - Google
            kSecAttrCreator              : Self.securityAttributeCreator,           // mark creator: Jet Email
            kSecAttrType                 : Self.securityAttributeTypeGoogleAccount, // mark this keychain type: Google Account
            kSecAttrAccount              : id.innerID, // account
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
            kSecReturnAttributes         : true,
            kSecReturnData               : true, // cannot use with kSecMatchLimitAll
            // kSecReturnRef                : true,
            kSecReturnPersistentRef      : true
        ] as [String: Any]
        
        var value: CFTypeRef?
        let resultCode = SecItemCopyMatching(query as CFDictionary, &value)
        switch resultCode {
        case errSecSuccess:
            let attributes   = value as! [CFString: Any]
            
            let username     = try (attributes[kSecAttrGeneric]         as! Data).string
            let keychainItem =      attributes[kSecValuePersistentRef] as! Data
            let gtmSession   = try (attributes[kSecValueData]           as! Data).gtmSession
            return .init(account: .init(id: id, username: username), gtmSession: gtmSession, keychainItem: keychainItem)
        case errSecItemNotFound:
            return nil
        default: fatalError()
        }
        
    }
    
    var items: [GoogleSessionItem] { get throws {
        //SessionKeychain.assertIsolated()
        checkBackgroundThread()
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
            // kSecReturnRef                : true,
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
            let items: [GoogleSessionItem] = try attriutesList.map { attributes in
                
                let id           = GoogleAccountID(innerID: attributes[kSecAttrAccount] as! String)
                let username     = try (attributes[kSecAttrGeneric] as! Data).string
                let keychainItem =      attributes[kSecValuePersistentRef] as! Data
                let query: [String: Any] = [
                    kSecValuePersistentRef  : keychainItem,
                    kSecReturnData: true,
                ] as [String: Any]
                
                var value: CFTypeRef?
                let resultCode = SecItemCopyMatching(query as CFDictionary, &value)
                assert(resultCode == errSecSuccess)
                let gtmSession = try (value as! Data).gtmSession
                
                return (.init(account: .init(id: id, username: username), gtmSession: gtmSession, keychainItem: keychainItem))
            }
            return items
            
        default: fatalError()
        }
    }   }
    
    func updateItem(_ item: GoogleSessionItem) throws -> GoogleSessionItem {
        checkBackgroundThread()
        let query = [
            kSecValuePersistentRef: item.keychainItem
        ] as [String : Any]
        let attributesToUpdate = [
            
            /* class */
            //kSecClass                    : kSecClassGenericPassword as String,
            
            /* attributes */
            //kSecAttrService              : "me.frogcjn.jet-email.account.google",      // mark location: Jet Email - Account - Google
            //kSecAttrCreator              : Self.securityAttributeCreator,              // mark creator: Jet Email
            //kSecAttrType                 : Self.securityAttributeTypeGoogleAccount,    // mark a data type: Google Account
            // kSecAttrAccount                : item.id.string,                                         // unique id under location and type
            
            //kSecAttrLabel                : "Jet Email - Google Account: \(item.username)",  // label
            
            /* protection attributes*/
            //kSecAttrAccessible           : kSecAttrAccessibleAfterFirstUnlock,
            // kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, (not migrate or recover from backup)
            // kSecAttrAccessGroup          : "ED72FQVT6C.com.microsoft.identity.universalstorage",
            // if kSecAttrAccessGroup set, kSecUseDataProtectionKeychain or kSecAttrSynchronizable must be true
            // kSecUseDataProtectionKeychain: true,
            // kSecAttrSynchronizable       : false,
            
            /* value */
            kSecValueData                  : try item.gtmSession.data,
            //kSecReturnAttributes         : true,
            //kSecReturnRef                : true,
            //kSecReturnPersistentRef      : true
        ] as [String : Any]
        
        let resultCode = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        assert(resultCode == errSecSuccess)
        return item
    }
    
}
// }

fileprivate extension GTMSession {
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
    var gtmSession: GTMSession {
        get throws {
            let keyedUnarchiver = try NSKeyedUnarchiver(forReadingFrom: self)
            keyedUnarchiver.requiresSecureCoding = true
            //keyedUnarchiver.setClass(GTMSession.self, forClassName: "GTMAppAuthFetcherAuthorization")

            guard let authSession = keyedUnarchiver.decodeObject(of: GTMSession.self, forKey: NSKeyedArchiveRootObjectKey) else {
                throw AuthError.decodeFromKeychainError
            }
            return authSession
        }
    }
}

fileprivate extension String {
    var fourCharUInt32: UInt32? {
        guard count == 4 else {
            fatalError("Input must be exactly four characters.")
            // return nil
        }
        
        var value: UInt32 = 0
        for (index, char) in utf8.enumerated() {
            value += UInt32(char) << (8 * (3 - index))
        }
        
        return value
    }
}

/*
 errSecSuccess                               = 0,       /* No error. */
 errSecUnimplemented                         = -4,      /* Function or operation not implemented. */
 errSecIO                                    = -36,     /*I/O error (bummers)*/
 errSecOpWr                                  = -49,     /*file already open with with write permission*/
 errSecParam                                 = -50,     /* One or more parameters passed to a function where not valid. */
 errSecAllocate                              = -108,    /* Failed to allocate memory. */
 errSecUserCanceled                          = -128,    /* User canceled the operation. */
 errSecBadReq                                = -909,    /* Bad parameter or invalid state for operation. */
 errSecInternalComponent                     = -2070,
 errSecNotAvailable                          = -25291,  /* No keychain is available. You may need to restart your computer. */
 errSecDuplicateItem                         = -25299,  /* The specified item already exists in the keychain. */
 errSecItemNotFound                          = -25300,  /* The specified item could not be found in the keychain. */
 errSecInteractionNotAllowed                 = -25308,  /* User interaction is not allowed. */
 errSecDecode                                = -26275,  /* Unable to decode the provided data. */
 errSecAuthFailed                            = -25293,  /* The user name or passphrase you entered is not correct. */
 */

extension GoogleSession {
    var _item: GoogleSessionItem { .init(account: account, gtmSession: _gtmSession, keychainItem: keychainItem) }
}
