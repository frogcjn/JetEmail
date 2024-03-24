//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import SwiftData // for ModelContext
import Foundation

enum FoudnationError : CodableErrorType, Sendable {
    case stringToData
    case dataToString
}

enum SwiftDataError : CodableErrorType, Sendable {
    //case noModelInstance(id: String, in: ModelContext)
    case noModelInstance(id: PersistentIdentifier)
    //ccase noGraphInstance(model: any PersistentModel)
}

public enum TreeError : CodableErrorType, Sendable {
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

enum ClassifyError : CodableErrorType, Sendable {
    case noArchiveFolder
}



struct JSONInitializationError: CodableErrorType, Sendable {}


/*enum MSALAPIError : Error {
    case description(String)
}*/
/*enum MSALAppError : Error {
    case getAccount(Error)
    case getTokenInteractivelyDoNotAllow
    case getTokenInteractively(Error)
    case getTokenSilently(Error)
}*/





public extension Error {
    var errorMessage: String {
        switch self {
        case let self as CustomStringConvertible:
            return String(describing: self)
        default:
            return localizedDescription
        }
    }
}


public enum SignInPresentationAnchorError : CodableErrorType, Sendable {
    case authorizeNoMainWindow
    case authorizeNoMainViewController
}
