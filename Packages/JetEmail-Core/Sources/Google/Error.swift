//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Foundation
import JetEmail_Foundation

    /*struct AuthError: LocalizedError {
        var message: String
    }*/
    
public enum AuthError : LocalizedError {
    case accountNoIDOrUsername
    case currentAuthorizationFlowIsExisted
    
    case sessionStoreAddFail
    case accountStoreExistedWhenAddNewToKeychain(Session)
    case accountStoreNotExistedWhenAddDuplicatedFound(GoogleAccountID)
    case accountStoreNotExistedWhenDelete(GoogleAccountID)
    case accountStoreNotExistedWhenUpdate(GoogleAccountID)

    case authorizeNoMainWindow
    case message(String)
    case decodeFromKeychainError
    case noAccountFound
}

public enum ResponseError : Error {
    case format
}


public enum GmailApiError: Error {
    /// Gmail API response parsing
    case failedToParseData(Sendable?)
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

public extension GmailApiError {
    static func convert(from error: NSError) -> GmailApiError {
        switch error.code {
        case -10: // invalid_grant error code
            return .invalidGrant(error)
        default:
            return .providerError(error)
        }
    }
}

public extension AppErr {
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

public enum AppErr: Error, CustomStringConvertible {
    // network
    case authentication
    case connection
    // code
    case nilSelf // guard let self = self else { throw AppErr.nilSelf }
    case unexpected(String) // we did not expect to ever see this error in practice

    /// something as? Something is unexpectedly nil
    case cast(Sendable)
    /// user error (user did something wrong?)
    case user(String)
    /// when you want to cancel execution without showing any error (eg after user clicks cancel button)
    case silentAbort
    case noCurrentUser
    case wrongMailProvider
    case general(String)

    public var description: String {
        switch self {
        case .connection: return "error_app_connection"
        case .wrongMailProvider: return "error_wrong_mail_provider"
        case let .general(message), let .user(message), let .unexpected(message):
            return message
        default: return errorMessage
        }
    }
}
