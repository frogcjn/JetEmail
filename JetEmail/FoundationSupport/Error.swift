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
    case noModelInstance(id: PersistentIdentifier, in: ModelContext)
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

enum GmailApiError: Error {
    /// Gmail API response parsing
    case failedToParseData(Any?)
    /// Can't get GTLREncodeBase64 data
    case messageEncode
    /// Missing message part
    case missingMessageInfo(String)
    /// Provider Error
    case providerError(Error)
    /// Search backup error
    case searchBackup(Error)
    /// Pagination Error
    // case paginationError(MessagesListPagination?)
    /// Invalid auth grant
    case invalidGrant(Error)
}

extension GmailApiError {
    static func convert(from error: NSError) -> GmailApiError {
        switch error.code {
        case -10: // invalid_grant error code
            return .invalidGrant(error)
        default:
            return .providerError(error)
        }
    }
}

extension AppErr {
    init(_ error: Error) {
        if let alreadyAppError = error as? AppErr {
            self = alreadyAppError
            return
        }
        if let gmailError = error as? GmailApiError {
            self = .general(gmailError.localizedDescription)
            return
        }
        self = .unexpected(error.localizedDescription)
        /*let code = (error as NSError).code
        switch code {
        case MCOErrorCode.authentication.rawValue:
            self = .authentication
        case MCOErrorCode.connection.rawValue,
             MCOErrorCode.tlsNotAvailable.rawValue:
            self = .connection
        default:
            self = .unexpected(error.localizedDescription)
        }*/
    }
}

enum AppErr: Error, CustomStringConvertible {
    // network
    case authentication
    case connection
    // code
    case nilSelf // guard let self = self else { throw AppErr.nilSelf }
    case unexpected(String) // we did not expect to ever see this error in practice

    /// something as? Something is unexpectedly nil
    case cast(Any)
    /// user error (user did something wrong?)
    case user(String)
    /// when you want to cancel execution without showing any error (eg after user clicks cancel button)
    case silentAbort
    case noCurrentUser
    case wrongMailProvider
    case general(String)

    var description: String {
        switch self {
        case .connection: return "error_app_connection"
        case .wrongMailProvider: return "error_wrong_mail_provider"
        case let .general(message), let .user(message), let .unexpected(message):
            return message
        default: return errorMessage
        }
    }
}

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

