//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//

import struct Foundation.Data
import struct Foundation.Date

extension PlatformEnum : MessageProtocol where
    Microsoft : MessageProtocol,
    Google: MessageProtocol,
    Microsoft.GeneralID == MessageID,
    Google.GeneralID == MessageID
{
    
    private subscript<Value>(platform keyPath: KeyPath<any MessageProtocol, Value>) -> Value {
        switch self {
        case .microsoft(let platform): platform[keyPath: keyPath]
        case    .google(let platform): platform[keyPath: keyPath]
        }
    }
    
    public var      subject: String?      { self[platform: \.subject     ] }
    
    public var         from: String?      { self[platform: \.from        ] }
    public var       sender: String?      { self[platform: \.sender      ] }
    public var      replyTo: String?      { self[platform: \.replyTo     ] }
    
    // MARK: Resource - Destination Address Fields

    public var           to: String?      { self[platform: \.to          ] }
    public var           cc: String?      { self[platform: \.cc          ] }
    public var          bcc: String?      { self[platform: \.bcc         ] }
    public var  deliveredTo: String?      { self[platform: \.deliveredTo ] }

    // MARK: Resource - Date

    public var         date: Date?        { self[platform: \.date        ] }
    public var  createdDate: Date?        { self[platform: \.createdDate ] }
    public var modifiedDate: Date?        { self[platform: \.modifiedDate] }
    public var receivedDate: Date?        { self[platform: \.receivedDate] }
    public var     sentDate: Date?        { self[platform: \.sentDate    ] }
    
    // MARK: Resource - Body & Raw
    
    public var  bodyPreview: String?      { self[platform: \.bodyPreview ] }
    public var         body: MessageBody? { self[platform: \.body        ] }
    public var          raw: Data?        { self[platform: \.raw         ] }
}


