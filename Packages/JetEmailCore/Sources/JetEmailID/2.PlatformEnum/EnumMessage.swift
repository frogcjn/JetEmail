//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//

import struct Foundation.Data
import struct Foundation.Date

public protocol GetMessageProtocol: GeneralIdentifiable where GeneralID : MessageIDProtocol {
    var      subject: String?      { get }
    
    // MARK: Resource - Originator Fields
    
    var         from: String?      { get }
    var       sender: String?      { get }
    var      replyTo: String?      { get }
    
    // MARK: Resource - Destination Address Fields

    var           to: String?      { get }
    var           cc: String?      { get }
    var          bcc: String?      { get }
    var  deliveredTo: String?      { get }

    // MARK: Resource - Date

    var         date: Date?        { get }
    var  createdDate: Date?        { get }
    var modifiedDate: Date?        { get }
    var receivedDate: Date?        { get }
    var     sentDate: Date?        { get }
    
    // MARK: Resource - Body & Raw
    
    var  bodyPreview: String?      { get }
    var         body: MessageBody? { get }
    var          raw: Data?        { get }
    // var   uniqueBody: Body?
}

extension PlatformEnum : GetMessageProtocol where
    Microsoft : GetMessageProtocol,
    Google : GetMessageProtocol, GeneralID : MessageIDProtocol
{
    
    private subscript<Value>(platform keyPath: KeyPath<any GetMessageProtocol, Value>) -> Value {
        switch self {
        case .microsoft(let platform): platform[keyPath: keyPath]
        case    .google(let platform): platform[keyPath: keyPath]
        }
    }
    
    public var      subject: String?      { self[platform: \.subject    ] }
    
    public var         from: String?      { self[platform: \.subject    ] }
    public var       sender: String?      { self[platform: \.sender     ] }
    public var      replyTo: String?      { self[platform: \.replyTo    ] }
    
    // MARK: Resource - Destination Address Fields

    public var           to: String?      { self[platform: \.to         ] }
    public var           cc: String?      { self[platform: \.cc         ] }
    public var          bcc: String?      { self[platform: \.bcc        ] }
    public var  deliveredTo: String?      { self[platform: \.deliveredTo] }

    // MARK: Resource - Date

    public var         date: Date?        { self[platform: \.date] }
    public var  createdDate: Date?        { self[platform: \.createdDate ] }
    public var modifiedDate: Date?        { self[platform: \.modifiedDate] }
    public var receivedDate: Date?        { self[platform: \.receivedDate] }
    public var     sentDate: Date?        { self[platform: \.sentDate    ] }
    
    // MARK: Resource - Body & Raw
    
    public var  bodyPreview: String?      { self[platform: \.bodyPreview] }
    public var         body: MessageBody? { self[platform: \.body       ] }
    public var          raw: Data?        { self[platform: \.raw        ] }
}



/*extension PlatformEnum: ResourceProtocol where Microsoft : PlatformSpecificDataProtocol, Google : PlatformSpecificDataProtocol, Microsoft.ID == ID, Google.ID == ID {
    
}*/
 // ResourceSpecificProtocol
