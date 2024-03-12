//
//  File.swift
//
//
//  Created by Cao, Jiannan on 3/11/24.
//

import struct Foundation.Data

public protocol GetMessageProtocol: MessageProtocol where ID : MessageIDProtocol {
    var  raw: Data?   { get }
}

extension PlatformEnum : MessageProtocol, GetMessageProtocol where
    Microsoft : PlatformSpecificMessageProtocol & GetMessageProtocol,
    Google : PlatformSpecificMessageProtocol & GetMessageProtocol, ID : MessageIDProtocol
{
    public var raw: Data? {
        switch self {
        case .microsoft(let platform): platform.raw
        case .google(let platform): platform.raw
        }
    }
    
    /*public var id: MessageID {
        switch self {
        case .microsoft(let platform): platform.id.general
        case .google(let platform): platform.id.general
        }
    }*/
}



/*extension PlatformEnum: ResourceProtocol where Microsoft : PlatformSpecificDataProtocol, Google : PlatformSpecificDataProtocol, Microsoft.ID == ID, Google.ID == ID {
    
}*/
 // ResourceSpecificProtocol
