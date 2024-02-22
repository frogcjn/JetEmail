//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData // for ModelContext
import Foundation

enum FoudnationError : Error {
    case stringToData
    case dataToString
}

enum SwiftDataError : Error {
    case noModelInstance(id: String, in: ModelContext)
    case noGraphInstance(model: any PersistentModel)
}

enum TreeError : Error {
    /*case multipleRoot*/
    case mailFolderNotInThisAccount
    case parentMailFolderNotInThisAccount
    case accountDoNotHaveRootFolder
    case mailFolderAlreadyHaveParent
    
    /*case noTargetParent
    case alreadyHaveChild
    case nodeAlreadyHaveChild*/
    /*case doNotHaveChild
    case doNotHaveRightParent
    case notFound
    case noModelContext
    case noLast*/
}

enum ClassifyError : Error {
    case noArchiveFolder
}

extension Microsoft {
    enum AuthError : Error {
        case accountNoIDOrUsername
        case collectionResponseNoCount
        case noAccountFound
        case notRightPlatform
    }
}

extension Google {
    /*struct AuthError: LocalizedError {
        var message: String
    }*/
    
    enum AuthError : LocalizedError {
        case accountNoIDOrUsername
        case currentAuthorizationFlowIsExisted
        
        case sessionStoreAddFail
        case accountStoreExistedWhenAddNewToKeychain(Google.Session)
        case accountStoreNotExistedWhenAddDuplicatedFound(Google.Account.ID)
        case accountStoreNotExistedWhenDelete(Google.Account.ID)
        case accountStoreNotExistedWhenUpdate(Google.Account.ID)

        case authorizeNoMainWindow
        case message(String)
        case decodeFromKeychainError
        case noAccountFound
    }
}


struct JSONInitializationError: Error {}

extension Microsoft {
    struct PublicError : Codable, Error {
        let code: String?
        let message: String?
        let innerError: JSON?
        let details: [JSON]?
    }
}


/*enum MSALAPIError : Error {
    case description(String)
}*/
/*enum MSALAppError : Error {
    case getAccount(Error)
    case getTokenInteractivelyDoNotAllow
    case getTokenInteractively(Error)
    case getTokenSilently(Error)
}*/
