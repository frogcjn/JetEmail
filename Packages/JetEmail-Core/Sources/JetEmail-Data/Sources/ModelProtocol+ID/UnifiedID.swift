//
//  ID.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 3/7/24.
//

import JetEmail_Foundation

public enum UnifiedID<Owner : UnifiedModel> : CodableValueType & PartialRawRepresentable {
    case microsoft(Owner.MicrosoftID)
    case    google(Owner.GoogleID)
    
}

public extension UnifiedID {

    var platform: Platform {
        switch self {
        case .microsoft: .microsoft
        case .google   : .google
        }
    }
    
    private var platformRawID: String {
        switch self {
        case .microsoft(let platformID): platformID.rawValue
        case .google   (let platformID): platformID.rawValue
        }
    }
    
    var rawValue: String { "\(platform)/\(platformRawID)" }
}






/*
extension UnifiedID : PartialRawRepresentable {
    public var rawValue: String { "\(platform.rawValue)/\(platformID)" }
}

extension UnifiedID : Sendable where MicrosoftID : Sendable, GoogleID : Sendable {}
extension UnifiedID : Hashable, Equatable, Encodable/* where Model.MicrosoftID : StringIDProtocol, Model.GoogleID: StringIDProtocol*/ {}
*/
