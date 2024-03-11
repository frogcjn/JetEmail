//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Foundation
import JetEmailID

public struct GoogleMessage : IdentifiableValueType {
    public let   id: GoogleMessageID
    public let data: GoogleMessageData
    
    public init(_ session: GoogleSession, data: GoogleMessageData) {
        self.id   = .init(accountID: session.accountID, innerID: data.id)
        self.data = data
    }
}

public struct GoogleMessageData : CodableValueType {
    public var                         id: String
    public var               internalDate: Int64?
    public var                    snippet: String?
    public var               sizeEstimate: Int?
    public var                        raw: Data?
    
    public var                    payload: Part?
    
    public var                   labelIds: [String]?
    public var                   threadId: String?
    public var                  historyId: UInt64?
    
    public struct Part : CodableValueType {
        public var   partID: String?
        public var filename: String?
        public var mimeType: String?
        public var  headers: [Header]?
        public var     body: Body?
        public var    parts: [Part]?
        
        public struct Header : CodableValueType {
            public var name: String
            public var value: String?
        }
        
        public struct Body : CodableValueType {
            public var size: Int
            public var data: Data?
            public var attachmentId: String?
        }
    }
}

public extension GoogleMessageData {
    func outer(_ session: GoogleSession) -> GoogleMessage {
        .init(session, data: self)
    }
}
