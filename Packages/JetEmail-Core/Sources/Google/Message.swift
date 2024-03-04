//
//  Google.Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import Foundation

public struct Message : Codable, Identifiable {
    public var                         id: ID
    public var               internalDate: Int64?
    public var                    snippet: String?
    public var               sizeEstimate: Int?
    public var                        raw: Data?
    
    public var                    payload: Part?
    
    public var                   labelIds: [String]?
    public var                   threadId: String?
    public var                  historyId: UInt64?
    
    public struct Part : Codable {
        public var   partID: String?
        public var filename: String?
        public var mimeType: String?
        public var  headers: [Header]?
        public var     body: Body?
        public var    parts: [Part]?
        
        public struct Header : Codable {
            public var name: String
            public var value: String?
        }
        
        public struct Body : Codable {
            public var size: Int
            public var data: Data?
            public var attachmentId: String?
        }
    }
}

