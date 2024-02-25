//
//  Google.Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import GoogleAPIClientForREST_Gmail

extension Google {
    struct Message : Codable, Identifiable {
        typealias Full = Message
        var                         id: ID
        var               internalDate: Int64?
        var                    snippet: String?
        var               sizeEstimate: Int?
        var                        raw: Data?
        
        var                    payload: Part?
        
        var                   labelIds: [String]?
        var                   threadId: String?
        var                  historyId: UInt64?
        
        struct Part : Codable {
            var   partID: String?
            var filename: String?
            var mimeType: String?
            var  headers: [Header]?
            var     body: Body?
            var    parts: [Part]?
            
            struct Header : Codable {
                var name: String
                var value: String?
            }
            
            struct Body : Codable {
                var size: Int
                var data: Data?
                var attachmentId: String?
            }
        }
    }
}
    
