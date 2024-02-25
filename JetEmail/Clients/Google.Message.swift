//
//  Google.Message.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 2/24/24.
//

import GoogleAPIClientForREST_Gmail

extension Google {
    struct Message : Codable, Identifiable {
        let                         id: ID
        
        let                   threadId: String?
        let                   labelIds: [String]?
        let                    snippet: String?
        let                  historyId: UInt64?
        let               internalDate: Int64?
        let                    payload: Part?
        let               sizeEstimate: Int?
        let                        raw: String?
        

        struct Part : Codable {
            let   partID: String?
            let mimeType: String?
            let filename: String?
            let  headers: [Header]?
            let     body: Body?
            let    parts: [Part]?
            
            struct Header : Codable {
                let name: String
                let value: String
            }
            
            struct Body : Codable {
                let attachmentId: String?
                let size: Int?
                let data: Data?
            }
        }
        

    }
    
    

    

    
    
    
    

    /*
     {
       "id": string,
       "threadId": string,
       "labelIds": [
         string
       ],
       "snippet": string,
       "historyId": string,
       "internalDate": string,
       "payload": {
         object (MessagePart)
       },
       "sizeEstimate": integer,
       "raw": string
     }
     
     MessagePart
     {
       "partId": string,
       "mimeType": string,
       "filename": string,
       "headers": [
         {
           object (Header)
         }
       ],
       "body": {
         object (MessagePartBody)
       },
       "parts": [
         {
           object (MessagePart)
         }
       ]
     }
     */
    
}

extension GTLRGmail_Message {
    var swift: Google.Message { get throws {
        guard let stringID = identifier else { throw Google.ResponseError.format }
        return .init(
            id          : .init(string: stringID),
            threadId    :     threadId,
            labelIds    :     labelIds,
            snippet     :     snippet,
            historyId   :     historyId?.uint64Value,
            internalDate:     internalDate?.int64Value,
            payload     : try payload?.swift,
            sizeEstimate:     sizeEstimate?.intValue,
            raw         :     raw
        )
    } }
}



extension GTLRGmail_MessagePart {
    var swift: Google.Message.Part { get throws {
        .init(
            partID: partId,
            mimeType: mimeType,
            filename: filename,
            headers : try headers?.map { try $0.swift },
            body    : try body?.swift,
            parts  : try parts?.map { try $0.swift }
        )
    } }
}

extension GTLRGmail_MessagePartHeader {
    var swift: Google.Message.Part.Header { get throws {
        guard let name, let value else { throw Google.ResponseError.format }
        return .init(
            name: name,
            value: value
        )
    } }
}

extension GTLRGmail_MessagePartBody {
    var swift: Google.Message.Part.Body? { get {
        return .init(
            attachmentId: attachmentId,
            size: size?.intValue,
            data: data.flatMap { GTLRDecodeWebSafeBase64($0) }
        )
            
    } }
}
