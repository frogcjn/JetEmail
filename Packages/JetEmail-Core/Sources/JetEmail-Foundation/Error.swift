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
    //case noModelInstance(id: String, in: ModelContext)
    case noModelInstance(id: PersistentIdentifier)
    //ccase noGraphInstance(model: any PersistentModel)
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



struct JSONInitializationError: Error {}


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

