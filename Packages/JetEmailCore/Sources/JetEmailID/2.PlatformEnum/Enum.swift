//
//  File.swift
//  
//
//  Created by Cao, Jiannan on 3/11/24.
//

public protocol GeneralIdentifiable : Sendable {
    associatedtype GeneralID : ResourceIDProtocol
    var generalID: GeneralID { get }
}

/*extension PlatformResourceProtocol where Self : PlatformCase, ID.GeneralID == PlatformCaseGeneralID {
    public var platformCaseGeneralID : PlatformCaseGeneralID { id.general }
}*/



public enum PlatformEnum<GeneralID: ResourceSpecificIDProtocol, Microsoft : GeneralIdentifiable, Google : GeneralIdentifiable> : GeneralIdentifiable where Microsoft.GeneralID == GeneralID, Google.GeneralID == GeneralID {
    case microsoft(Microsoft)
    case    google(Google)
                   
    public var generalID: GeneralID {
        switch self {
        case .microsoft(let platform): platform.generalID
        case    .google(let platform): platform.generalID
        }
    }
}

public extension PlatformEnum {
    var microsoft: Microsoft? {
        guard case .microsoft(let microsoft) = self else { return nil }
        return microsoft
    }
    
    var google: Google? {
        guard case .google(let google) = self else { return nil }
        return google
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



