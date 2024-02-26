//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData // for ModelContext
import Foundation
import JetEmail_Foundation


extension Microsoft {
    enum AuthError : Error {
        case accountNoIDOrUsername
        case collectionResponseNoCount
        case noAccountFound
        case notRightPlatform
    }
}
/*
extension Google {
    /*struct AuthError: LocalizedError {
        var message: String
    }*/
    
    enum AuthError : LocalizedError {
        case accountNoIDOrUsername
        case currentAuthorizationFlowIsExisted
        
        case sessionStoreAddFail
        case accountStoreExistedWhenAddNewToKeychain(Google.Session)
        case accountStoreNotExistedWhenAddDuplicatedFound(Google.ID)
        case accountStoreNotExistedWhenDelete(Google.ID)
        case accountStoreNotExistedWhenUpdate(Google.ID)

        case authorizeNoMainWindow
        case message(String)
        case decodeFromKeychainError
        case noAccountFound
    }
    
    enum ResponseError : Error {
        case format
    }
}
*/


extension Microsoft {
    struct PublicError : Codable, Error {
        let code: String?
        let message: String?
        let innerError: JSON?
        let details: [JSON]?
    }
}
