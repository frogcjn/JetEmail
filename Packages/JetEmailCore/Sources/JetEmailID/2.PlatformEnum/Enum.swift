//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public protocol PlatformSpecificCase : Sendable {
    associatedtype PlatformCaseGeneralID : ResourceIDProtocol
    var platformCaseGeneralID: PlatformCaseGeneralID { get }
}

/*extension PlatformResourceProtocol where Self : PlatformCase, ID.GeneralID == PlatformCaseGeneralID {
    public var platformCaseGeneralID : PlatformCaseGeneralID { id.general }
}*/



public enum PlatformEnum<ID: ResourceSpecificIDProtocol, Microsoft : PlatformSpecificCase, Google : PlatformSpecificCase> : Identifiable & Sendable where Microsoft.PlatformCaseGeneralID == ID, Google.PlatformCaseGeneralID == ID {
    case microsoft(Microsoft)
    case    google(Google)
                   
    public var id: ID {
        switch self {
        case .microsoft(let platform): platform.platformCaseGeneralID
        case .google(let platform): platform.platformCaseGeneralID
        }
    }
}

extension PlatformEnum: Equatable where Microsoft : Equatable, Google : Equatable {}
extension PlatformEnum:  Hashable where Microsoft :  Hashable, Google :  Hashable {}
extension PlatformEnum:   Codable where Microsoft :   Codable, Google :   Codable {}

//extension PlatformEnum: Equatable, Hashable, Codable where Microsoft : CodableValueType, Google : CodableValueType {}




//extension PlatformEnum: ResourceSpecificIDProtocol where Microsoft : PlatformSpecificAccountIDProtocol, Google : PlatformSpecificAccountIDProtocol {}
//extension PlatformEnum: AccountIDProtocol          where Microsoft : PlatformSpecificAccountIDProtocol, Google : PlatformSpecificAccountIDProtocol {}

/*extension PlatformEnum : ResourceProtocol where Microsoft : PlatformResourceProtocol, Google : PlatformResourceProtocol, Microsoft.ID : PlatformSpecificIDProtocol, Google.ID : PlatformSpecificIDProtocol, Microsoft.PlatformCaseGeneralID == ID, Google.PlatformCaseGeneralID == ID {}*/
/*
public enum PlatformEnum2<ID: ResourceIDProtocol, Microsoft : PlatformResourceProtocol, Google : PlatformResourceProtocol> : ResourceProtocol where Microsoft.ID : PlatformSpecificResourceIDProtocol, Google.ID : PlatformSpecificResourceIDProtocol, Microsoft.ID.GeneralID == ID, Google.ID.GeneralID == ID {
    case microsoft(Microsoft)
    case    google(Google)
    
    public var id: ID {
        switch self {
        case .microsoft(let platform): platform.id.general
        case .google(let platform): platform.id.general
        }
    }
}*/



