//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmail_ID
import JetEmail_Foundation // for JSON

public enum AuthError : CodableErrorType {
    case accountNoIDOrUsername
    case collectionResponseNoCount
    case noAccountFound
    case notRightPlatform
    case authorizeNoMainWindow
}

public struct PublicError : CodableErrorType {
    public let code: String?
    public let message: String?
    public let innerError: JSON?
    public let details: [JSON]?
}
