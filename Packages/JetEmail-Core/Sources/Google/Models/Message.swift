//
//  Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import JetEmail_Foundation
import Foundation

public struct Message : IdentifiableValueType {
    public var                         id: ID
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
