//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import JetEmailData
import JetEmailFoundation // for JSON

public enum AuthError : CodableErrorType, Sendable {
    case accountNoIDOrUsername
    case collectionResponseNoCount
    case noAccountFound
    case notRightPlatform
    case authorizeNoMainWindow
    case batchRequestOffsetBody
}

public struct PublicError : CodableErrorType, Sendable {
    public let code: String?
    public let message: String?
    public let innerError: JSON?
    public let details: [JSON]?
}
