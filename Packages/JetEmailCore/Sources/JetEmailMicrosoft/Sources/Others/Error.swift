//
//  Error.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/15/24.
//

import typealias JetEmailFoundation.CodableErrorType
import enum      JetEmailFoundation.JSON
import JetEmailData

public enum MicrosoftAuthError : CodableErrorType, Sendable {
    case accountNoIDOrUsername
}
public enum MicrosoftAPIError : CodableErrorType, Sendable {
    case prePathNotTheSame
    case pathComponentNotTheSame
    case collectionResponseNoCount
    case batchRequestWrongOffsetOrBody
    case publicError(Public)

    public struct Public : CodableErrorType, Sendable {
        public let       code: String?
        public let    message: String?
        public let innerError: JSON?
        public let    details: [JSON]?
    }
}
