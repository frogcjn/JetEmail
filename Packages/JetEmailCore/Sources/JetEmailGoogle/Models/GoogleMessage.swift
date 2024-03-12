//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import struct Foundation.Data
import JetEmailID

public struct GoogleMessage : GoogleProtocol, PlatformSpecificMessageProtocol, GetMessageProtocol {
    public var platformCaseGeneralID: MessageID {
        id.general
    }
    
    public typealias PlatformCaseGeneralID = MessageID
    public let                  id: GoogleMessageID
    public let               inner: GoogleMessageInner
    public var       downloadedRaw: Data? // combined from other request
    public var                 raw: Data? { downloadedRaw }

    public init(id: GoogleMessageID, inner: GoogleMessageInner) {
        self.id    = id
        self.inner = inner
    }
}
// https://learn.microsoft.com/en-us/graph/api/resources/message
public struct GoogleMessageInner : IdentifiableValueType, Sendable {
    public let                         id: String
    public let               internalDate: Int64?
    public let                    snippet: String?
    public let               sizeEstimate: Int?
    public let                        raw: Data?
    
    public let                    payload: Part?
    
    public let                   labelIds: [String]?
    public let                   threadId: String?
    public let                  historyId: UInt64?
    
    public init(id: String, internalDate: Int64?, snippet: String?, sizeEstimate: Int?, raw: Data?, payload: Part?, labelIds: [String]?, threadId: String?, historyId: UInt64?) {
        self.id = id
        self.internalDate = internalDate
        self.snippet = snippet
        self.sizeEstimate = sizeEstimate
        self.raw = raw
        self.payload = payload
        self.labelIds = labelIds
        self.threadId = threadId
        self.historyId = historyId
    }
    
    public struct Part : CodableValueType, Sendable {
        public let   partID: String?
        public let filename: String?
        public let mimeType: String?
        public let  headers: [Header]?
        public let     body: Body?
        public let    parts: [Part]?
        
        public init(partID: String?, filename: String?, mimeType: String?, headers: [Header]?, body: Body?, parts: [Part]?) {
            self.partID = partID
            self.filename = filename
            self.mimeType = mimeType
            self.headers = headers
            self.body = body
            self.parts = parts
        }
        
        public struct Header : CodableValueType, Sendable {
            public let name: String
            public let value: String?
            public init(name: String, value: String?) {
                self.name = name
                self.value = value
            }
        }
        
        public struct Body : CodableValueType, Sendable {
            public let size: Int
            public let data: Data?
            public let attachmentId: String?
            public init(size: Int, data: Data?, attachmentId: String?) {
                self.size = size
                self.data = data
                self.attachmentId = attachmentId
            }
        }
    }
}
