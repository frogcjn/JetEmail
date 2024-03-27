//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 2/25/24.
//

import Foundation
import JetEmailData

public enum GoogleAuthError : CodableErrorType, Sendable {
    case accountNoIDOrUsername
    case sessionStoreAddFail
    case OIDAuthStateCompletionFail
    case decodeFromKeychainError
}

public enum GoogleAPIError: Error, Sendable {
    case collectionResponseNoCount
    case failedToParseData(Sendable?)
    case missingMessageInfo(String)
    case providerError(Error)
    case invalidGrant(Error)
    case cast(Sendable)
    
    static func convert(from error: NSError) -> GoogleAPIError {
        switch error.code {
        case -10: // invalid_grant error code
            return .invalidGrant(error)
        default:
            return .providerError(error)
        }
    }
}
